import json
import shutil
import zipfile
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from flask import Blueprint, current_app, jsonify, request
from osgeo import ogr
from pyproj import CRS
from pyproj.exceptions import CRSError
from sqlalchemy import select

from app.extensions import db
from app.models import Lote, LoteHistorico

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


def _validate_field_lengths(
    layer, field_map: Dict[str, str]
) -> Tuple[Dict[str, List[int]], List[int]]:
    errores: Dict[str, List[int]] = {
        "cod_sector": [],
        "cod_mzna": [],
        "cod_lote": [],
    }
    registros_todos_vacios: List[int] = []

    layer.ResetReading()
    feature = layer.GetNextFeature()
    index = 1
    while feature is not None:
        sector_val = (feature.GetField(field_map["cod_sector"]) or "").strip()
        mzna_val = (feature.GetField(field_map["cod_mzna"]) or "").strip()
        lote_val = (feature.GetField(field_map["cod_lote"]) or "").strip()

        if not sector_val and not mzna_val and not lote_val:
            registros_todos_vacios.append(index)
            feature = layer.GetNextFeature()
            index += 1
            continue

        if len(sector_val) != 2 or not sector_val.isdigit():
            errores["cod_sector"].append(index)
        if len(mzna_val) != 3 or not mzna_val.isdigit():
            errores["cod_mzna"].append(index)
        if len(lote_val) != 3 or not lote_val.isdigit():
            errores["cod_lote"].append(index)

        feature = layer.GetNextFeature()
        index += 1

    return errores, registros_todos_vacios


def _geometry_is_polygon(layer) -> bool:
    geom_type = layer.GetGeomType()
    geom_name = ogr.GeometryTypeToName(geom_type) or ""
    return "POLYGON" in geom_name.upper()


def _get_layer_srid(layer, expected_epsg: Optional[int] = None) -> Optional[str]:
    try:
        spatial_ref = layer.GetSpatialRef()
    except RuntimeError:
        return None

    if spatial_ref is None:
        return None

    authority_name: Optional[str]
    authority_code: Optional[str]
    try:
        authority_name = spatial_ref.GetAuthorityName(None)
        authority_code = spatial_ref.GetAuthorityCode(None)
    except RuntimeError:
        authority_name = None
        authority_code = None

    if authority_name and authority_code:
        return authority_code

    wkt: Optional[str]
    try:
        wkt = spatial_ref.ExportToWkt()
    except RuntimeError:
        wkt = None

    if not wkt:
        return None

    try:
        crs = CRS.from_wkt(wkt)
    except CRSError:
        return None

    epsg_code = crs.to_epsg()
    if epsg_code is not None:
        return str(epsg_code)

    if expected_epsg is not None:
        try:
            expected_crs = CRS.from_epsg(expected_epsg)
        except CRSError:
            return None

    if crs == expected_crs or crs.is_exact_same(expected_crs):
            return str(expected_epsg)

    return None


@lotes_bp.route("/subir_shapefile", methods=["POST"])
def subir_shapefile():
    file = request.files.get("file")
    if not file or not file.filename.lower().endswith(".zip"):
        return jsonify({"estado": False, "mensaje": "Archivo inválido"}), 400

    tmp_dir = Path(current_app.config["TMP_DIR"])
    uploads_dir = Path(current_app.config["UPLOADS_DIR"])

    tmp_dir.mkdir(parents=True, exist_ok=True)
    uploads_dir.mkdir(parents=True, exist_ok=True)

    _clear_directory(tmp_dir)

    zip_path = tmp_dir / file.filename
    file.save(zip_path)

    try:
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(tmp_dir)
    except zipfile.BadZipFile:
        zip_path.unlink(missing_ok=True)
        _clear_directory(tmp_dir)
        return jsonify({"estado": False, "mensaje": "El archivo ZIP está corrupto"}), 400

    zip_path.unlink(missing_ok=True)

    shapefiles = list(tmp_dir.rglob("*.shp"))
    if not shapefiles:
        _clear_directory(tmp_dir)
        return jsonify(
            {
                "estado": False,
                "mensaje": "No se encontró un archivo .shp válido en el comprimido",
            }
        ), 404

    if len(shapefiles) > 1:
        _clear_directory(tmp_dir)
        return jsonify(
            {
                "estado": False,
                "mensaje": "El archivo comprimido debe contener exactamente un Shapefile",
            }
        ), 400

    timestamp = datetime.now().strftime("%d%m%Y%H%M%S")
    final_path = uploads_dir / timestamp

    if final_path.exists():
        shutil.rmtree(final_path)
    shutil.copytree(tmp_dir, final_path)

    _clear_directory(tmp_dir)

    return jsonify(
        {
            "estado": True,
            "mensaje": "Descomprimido correctamente",
            "nombreCarpeta": timestamp,
        }
    ), 200


@lotes_bp.route("/validar_shapefile", methods=["POST"])
def validar_shapefile():
    try:
        payload = request.get_json(silent=True) or {}

        carpeta = payload.get("nombreCarpeta")
        codigo_sector = payload.get("codigoSector")
        codigo_manzana = payload.get("codigoManzana")
        codigo_lote = payload.get("codigoLote")

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

        if not _geometry_is_polygon(layer):
            datasource = None
            layer = None
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "La capa debe contener geometrías de tipo POLYGON",
                    }
                ),
                400,
            )

        srid = _get_layer_srid(layer, expected_epsg=32719)
        if srid != "32719":
            datasource = None
            layer = None
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "La proyección del Shapefile debe ser EPSG:32719",
                    }
                ),
                400,
            )

        field_map = {
            "cod_sector": sector_field,
            "cod_mzna": mzna_field,
            "cod_lote": lote_field,
        }

        errores, registros_todos_vacios = _validate_field_lengths(layer, field_map)

        errores_detectados = {
            clave: indices for clave, indices in errores.items() if indices
        }

        layer.ResetReading()
        contador = Counter()
        registros_campos_vacios = 0
        feature = layer.GetNextFeature()
        while feature is not None:
            sector_val = (feature.GetField(sector_field) or "").strip()
            mzna_val = (feature.GetField(mzna_field) or "").strip()
            lote_val = (feature.GetField(lote_field) or "").strip()

            if not sector_val and not mzna_val and not lote_val:
                registros_campos_vacios += 1
                contador["Vacio"] += 1
            elif sector_val:
                contador[sector_val] += 1
            else:
                contador["Vacio"] += 1
            feature = layer.GetNextFeature()

        reporte = [
            {"codSector": cod_sector, "totalRegistros": total}
            for cod_sector, total in sorted(contador.items())
        ]

        datasource = None
        layer = None

        if errores_detectados:
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "Se encontraron errores en los códigos del shapefile",
                        "errores": errores_detectados,
                        "reporte": reporte,
                    }
                ),
                400,
            )

        if registros_campos_vacios or registros_todos_vacios:
            return (
                jsonify(
                    {
                        "estado": False,
                        "mensaje": "Shapefile validado correctamente",
                        "reporte": reporte,
                    }
                ),
                200,
            )

        metadata_path = carpeta_path / "validation.json"
        metadata = {
            "validado": True,
            "campoSector": sector_field,
            "campoManzana": mzna_field,
            "campoLote": lote_field,
            "fechaValidacion": datetime.utcnow().isoformat(),
        }

        metadata_path.write_text(
            json.dumps(metadata, ensure_ascii=False, indent=2), encoding="utf-8"
        )

        return (
            jsonify(
                {
                    "estado": True,
                    "mensaje": "Shapefile validado correctamente",
                    "reporte": reporte,
                }
            ),
            200,
        )

    except Exception as exc:  # pragma: no cover
        return (
            jsonify({"estado": False, "mensaje": f"Error inesperado: {exc}"}),
            500,
        )


@lotes_bp.route("/cargar_shapefile", methods=["POST"])
def cargar_shapefile():
    payload = request.get_json(silent=True) or {}

    carpeta = payload.get("nombreCarpeta")
    usuario_id = payload.get("id_usuario")

    if not carpeta or usuario_id is None:
        return (
            jsonify(
                {
                    "estado": False,
                    "mensaje": "Los parámetros 'nombreCarpeta' e 'id_usuario' son obligatorios",
                }
            ),
            400,
        )

    try:
        usuario_id = int(usuario_id)
    except (TypeError, ValueError):
        return (
            jsonify(
                {
                    "estado": False,
                    "mensaje": "El parámetro 'id_usuario' debe ser numérico",
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

    metadata_path = carpeta_path / "validation.json"
    if not metadata_path.exists():
        return (
            jsonify(
                {
                    "estado": False,
                    "mensaje": "Debe validar el Shapefile antes de cargarlo",
                }
            ),
            400,
        )

    try:
        metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return (
            jsonify(
                {
                    "estado": False,
                    "mensaje": "No se pudo leer la información de validación",
                }
            ),
            500,
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

    sector_field = metadata.get("campoSector")
    mzna_field = metadata.get("campoManzana")
    lote_field = metadata.get("campoLote")

    if not all([sector_field, mzna_field, lote_field]):
        datasource = None
        layer = None
        return (
            jsonify(
                {
                    "estado": False,
                    "mensaje": "La información de validación es incompleta",
                }
            ),
            400,
        )

    cod_sectores = set()
    layer.ResetReading()
    feature = layer.GetNextFeature()
    while feature is not None:
        sector_val = (feature.GetField(sector_field) or "").strip()
        if sector_val:
            cod_sectores.add(sector_val)
        feature = layer.GetNextFeature()

    fecha_operacion = datetime.utcnow()
    historico_registros = 0
    insertados = 0

    try:
        with db.session.begin():
            if cod_sectores:
                existing_lotes = (
                    db.session.execute(
                        select(Lote).where(Lote.cod_sector.in_(cod_sectores))
                    )
                    .scalars()
                    .all()
                )

                historico_registros = len(existing_lotes)

                for lote in existing_lotes:
                    historico = LoteHistorico.from_lote(
                        lote, usuario_id, fecha_operacion
                    )
                    db.session.add(historico)
                    db.session.delete(lote)

            layer.ResetReading()
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
                    id_usuario=usuario_id,
                    fech_actua=fecha_actualizacion,
                    geom=wkt_geom,
                )

                db.session.add(nuevo)
                insertados += 1
                feature = layer.GetNextFeature()
    except Exception as exc:  # pragma: no cover
        db.session.rollback()
        datasource = None
        layer = None
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
                "mensaje": "Datos migrados exitosamente",
                "registrosInsertados": insertados,
                "registrosHistorico": historico_registros,
            }
        ),
        200,
    )
