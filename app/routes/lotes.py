import shutil
import zipfile
from datetime import datetime
from pathlib import Path
from typing import Optional

from flask import Blueprint, current_app, jsonify, request
from osgeo import ogr
from sqlalchemy import select

from app.extensions import db
from app.models import Lote_historico, Lote

ogr.UseExceptions()

lotes_bp = Blueprint("lotes", __name__)


@lotes_bp.route("/")
def inicio():
    if current_app.config.get("IS_DEV", False):
        return "🟢 [DESAROLLO] - MDW | API-GIS"
    return "🟢 MDW | API-GIS"


def _clear_directory(path: Path) -> None:
    if not path.exists():
        return
    for item in path.iterdir():
        if item.is_file():
            item.unlink()
        else:
            shutil.rmtree(item)


def _find_shapefile(directory: Path) -> Optional[Path]:
    for shp_file in directory.rglob("*.shp"):
        return shp_file
    return None


def _find_field(layer, target_name: str) -> Optional[str]:
    layer_definition = layer.GetLayerDefn()
    for index in range(layer_definition.GetFieldCount()):
        field_definition = layer_definition.GetFieldDefn(index)
        if field_definition.GetName().lower() == target_name.lower():
            return field_definition.GetName()
    return None


@lotes_bp.route("/subir_shapefile", methods=["POST"])
def subir_shapefile():
    file = request.files.get("file")
    user_id = request.form.get("idUsuario")

    if not file or not file.filename.endswith(".zip"):
        return jsonify({"estado": False, "mensaje": "Archivo inválido"}), 400

    if not user_id:
        return jsonify({
            "estado": False,
            "mensaje": "El identificador del usuario es obligatorio para procesar el histórico",
        }), 400

    try:
        user_id = int(user_id)
    except (TypeError, ValueError):
        return jsonify({
            "estado": False,
            "mensaje": "El identificador del usuario debe ser numérico",
        }), 400

    tmp_dir = Path(current_app.config["TMP_DIR"])
    uploads_dir = Path(current_app.config["UPLOADS_DIR"])

    _clear_directory(tmp_dir)

    zip_path = tmp_dir / file.filename
    file.save(zip_path)

    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        zip_ref.extractall(tmp_dir)

    zip_path.unlink(missing_ok=True)

    shapefile_path = _find_shapefile(tmp_dir)
    if shapefile_path is None:
        return jsonify({
            "estado": False,
            "mensaje": "No se encontró un archivo .shp válido en el comprimido",
        }), 404

    datasource = ogr.Open(str(shapefile_path))
    if datasource is None:
        return jsonify({
            "estado": False,
            "mensaje": f"No se pudo abrir el archivo Shapefile: {shapefile_path.name}",
        }), 500

    layer = datasource.GetLayer()
    if layer is None:
        datasource = None
        return jsonify({
            "estado": False,
            "mensaje": "El archivo Shapefile no contiene capas válidas",
        }), 500

    field_name = _find_field(layer, "cod_sector")
    if field_name is None:
        layer = None
        datasource = None
        return jsonify({
            "estado": False,
            "mensaje": "El archivo Shapefile no tiene el campo 'cod_sector'",
        }), 400

    cod_sectores = set()
    layer.ResetReading()
    feature = layer.GetNextFeature()
    while feature is not None:
        value = feature.GetField(field_name)
        if value not in (None, ""):
            cod_sectores.add(str(value).strip())
        feature = layer.GetNextFeature()

    layer = None
    datasource = None

    historico_registros = 0
    fecha_operacion = datetime.utcnow()

    if cod_sectores:
        try:
            with db.session.begin():
                existing_lotes = (
                    db.session.execute(
                        select(Lote).where(Lote.cod_sector.in_(cod_sectores))
                    )
                    .scalars()
                    .all()
                )

                historico_registros = len(existing_lotes)

                for lote in existing_lotes:
                    historico = Lote_historico.from_lote(lote, user_id, fecha_operacion)
                    db.session.add(historico)
                    db.session.delete(lote)
        except Exception as exc:  # pragma: no cover
            db.session.rollback()
            return jsonify({
                "estado": False,
                "mensaje": f"Error al mover los registros al histórico: {exc}",
            }), 500

    timestamp = datetime.now().strftime("%d%m%Y%H%M%S")
    final_path = uploads_dir / timestamp

    if final_path.exists():
        shutil.rmtree(final_path)
    shutil.copytree(tmp_dir, final_path)

    return jsonify(
        {
            "estado": True,
            "mensaje": "Descomprimido correctamente",
            "nombreCarpeta": timestamp,
            "codSectoresDetectados": len(cod_sectores),
            "codSectores": sorted(cod_sectores),
            "registrosHistorico": historico_registros,
        }
    ), 200


@lotes_bp.route("/insertar_datos", methods=["POST"])
def insertar_datos():
    try:
        payload = request.get_json(silent=True) or {}

        carpeta = payload.get("nombreCarpeta")
        codigo_sector = payload.get("codigoSector")
        codigo_manzana = payload.get("codigoManzana")
        codigo_lote = payload.get("codigoLote")
        codigo_usuario = payload.get("codigoUsuario")

        if not all([carpeta, codigo_sector, codigo_manzana, codigo_lote]):
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "Faltan parámetros requeridos en la solicitud",
                    }
                ),
                400,
            )

        carpeta_path = Path(current_app.config["UPLOADS_DIR"]) / carpeta
        if not carpeta_path.exists():
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": f"No existe la carpeta indicada: {carpeta}",
                    }
                ),
                404,
            )

        shapefile_path = _find_shapefile(carpeta_path)
        if shapefile_path is None:
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": f"No se encontró archivo .shp en la carpeta: {carpeta}",
                    }
                ),
                404,
            )

        datasource = ogr.Open(str(shapefile_path))
        if datasource is None:
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": f"No se pudo abrir el archivo Shapefile: {shapefile_path}",
                    }
                ),
                500,
            )

        layer = datasource.GetLayer()
        if layer is None:
            datasource = None
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "El archivo Shapefile no contiene capas válidas",
                    }
                ),
                500,
            )

        sector_field = _find_field(layer, codigo_sector)
        mzna_field = _find_field(layer, codigo_manzana)
        lote_field = _find_field(layer, codigo_lote)
        usuario_field = _find_field(layer, codigo_usuario) if codigo_usuario else None

        if not all([sector_field, mzna_field, lote_field]):
            datasource = None
            layer = None
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "El archivo Shapefile no contiene los campos requeridos",
                    }
                ),
                400,
            )

        layer.ResetReading()

        insertados = 0
        try:
            with db.session.begin():
                feature = layer.GetNextFeature()
                while feature is not None:
                    geometry = feature.GetGeometryRef()
                    if geometry is not None:
                        geometry.FlattenTo2D()
                    wkt_geom = geometry.ExportToWkt() if geometry else None

                    area = geometry.GetArea() if geometry else None
                    perimeter = geometry.Length() if geometry else None

                    sector = (feature.GetField(sector_field) or "").strip()
                    mzna = (feature.GetField(mzna_field) or "").strip()
                    lote = (feature.GetField(lote_field) or "").strip()

                    usuario_valor = None
                    if usuario_field:
                        raw_usuario = feature.GetField(usuario_field)
                        if raw_usuario not in (None, ""):
                            try:
                                usuario_valor = int(raw_usuario)
                            except (TypeError, ValueError):
                                usuario_valor = None

                    fecha_actualizacion = datetime.utcnow().date()

                    nuevo = Lote(
                        cod_sector=sector,
                        id_ubigeo="080108",
                        id_sector=f"080108{sector}",
                        cod_mzna=mzna,
                        id_mzna=f"080108{sector}{mzna}",
                        cod_lote=lote,
                        id_lote=f"080108{sector}{mzna}{lote}",
                        area_grafi=area,
                        peri_grafi=perimeter,
                        id_usuario=usuario_valor,
                        fech_actua=fecha_actualizacion,
                        geom=wkt_geom,
                    )

                    db.session.add(nuevo)
                    insertados += 1
                    feature = layer.GetNextFeature()
        except Exception as exc:  # pragma: no cover
            db.session.rollback()
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": f"Error al procesar los datos: {exc}",
                    }
                ),
                500,
            )
        finally:
            layer = None
            datasource = None

        return (
            jsonify(
                {
                    "estado": True,
                    "mensaje": f"Datos migrados exitosamente. Registros insertados: {insertados}",
                    "registrosInsertados": insertados,
                }
            ),
            200,
        )

    except Exception as exc:  # pragma: no cover
        return (
            jsonify(
                {
                    "estado": False,
                    "mensaje": f"Error inesperado: {exc}",
                }
            ),
            500,
        )