from datetime import datetime
from pathlib import Path

from flask import Blueprint, current_app, jsonify, request
from sqlalchemy import select

from app.extensions import db
from app.models import Manzana, ManzanaHistorico
from app.routes.shapefile_utils import (
  FieldSpec,
  ID_UBIGEO,
  extract_fields,
  find_field,
  find_shapefile,
  geometry_matches,
  get_layer_srid,
  handle_gdal_missing,
  handle_shapefile_upload,
  load_metadata,
  open_shapefile_layer,
  store_metadata,
  validate_fields,
)

manzanas_bp = Blueprint("manzanas", __name__, url_prefix='/manzanas')

@manzanas_bp.route("/subir_shapefile", methods=["POST"])
def subir_shapefile():
  payload, status = handle_shapefile_upload(request.files.get("file"))
  return jsonify(payload), status

@manzanas_bp.route("/validar_shapefile", methods=["POST"])
@handle_gdal_missing
def validar_shapefile():
  payload = request.get_json(silent=True) or {}

  carpeta = payload.get("nombreCarpeta")
  codigo_sector = payload.get("codigoSector")
  codigo_manzana = payload.get("codigoManzana")

  if not all([carpeta, codigo_sector, codigo_manzana]):
    return (
      jsonify(
        {
          "estado": False,
          "mensaje": "Los parámetros 'nombreCarpeta', 'codigoSector' y 'codigoManzana' son obligatorios",
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

  shapefile_path = find_shapefile(carpeta_path)
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

  datasource, layer = open_shapefile_layer(shapefile_path)
  if datasource is None or layer is None:
      return (
          jsonify(
              {
                  "estado": False,
                  "mensaje": f"No se pudo abrir el archivo Shapefile: {shapefile_path}",
              }
          ),
          500,
      )

  sector_field = find_field(layer, codigo_sector)
  manzana_field = find_field(layer, codigo_manzana)

  if not all([sector_field, manzana_field]):
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

  if not geometry_matches(layer, "POLYGON"):
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

  srid = get_layer_srid(layer, expected_epsg=32719)
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
      "cod_mzna": manzana_field,
  }

  errores, registros_vacios, contador = validate_fields(
      layer,
      field_map,
      (
          FieldSpec("cod_sector", length=2, numeric=True),
          FieldSpec("cod_mzna", length=3, numeric=True),
      ),
      "cod_sector",
  )

  reporte = [
      {"codSector": cod_sector, "totalRegistros": total}
      for cod_sector, total in sorted(contador.items())
  ]

  datasource = None
  layer = None

  if errores:
      return (
          jsonify(
              {
                  "estado": False,
                  "mensaje": "Se encontraron errores en los códigos del shapefile",
                  "errores": errores,
                  "reporte": reporte,
              }
          ),
          400,
      )

  if registros_vacios:
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

  metadata = {
      "validado": True,
      "fields": field_map,
      "fechaValidacion": datetime.utcnow().isoformat(),
  }

  metadata_path = carpeta_path / "validation.json"
  store_metadata(metadata_path, metadata)

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

@manzanas_bp.route("/cargar_shapefile", methods=["POST"])
@handle_gdal_missing
def cargar_shapefile():
  payload = request.get_json(silent=True) or {}

  carpeta = payload.get("nombreCarpeta")
  id_usuario = payload.get("id_usuario")

  if not carpeta or id_usuario is None:
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
      id_usuario = int(id_usuario)
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
  metadata = load_metadata(metadata_path)
  if metadata is None:
      return (
          jsonify(
              {
                  "estado": False,
                  "mensaje": "Debe validar el Shapefile antes de cargarlo",
              }
          ),
          400,
      )

  shapefile_path = find_shapefile(carpeta_path)
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

  datasource, layer = open_shapefile_layer(shapefile_path)
  if datasource is None or layer is None:
      return (
          jsonify(
              {
                  "estado": False,
                  "mensaje": f"No se pudo abrir el archivo Shapefile: {shapefile_path}",
              }
          ),
          500,
      )

  fields = extract_fields(
      metadata,
      ("cod_sector", "cod_mzna"),
      {"cod_sector": "campoSector", "cod_mzna": "campoManzana"},
  )

  if not fields:
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

  sector_field = fields["cod_sector"]
  manzana_field = fields["cod_mzna"]

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
              existentes = (
                  db.session.execute(
                      select(Manzana).where(Manzana.cod_sector.in_(cod_sectores))
                  )
                  .scalars()
                  .all()
              )

              historico_registros = len(existentes)

              for manzana in existentes:
                  historico = ManzanaHistorico.from_manzana(
                      manzana, id_usuario, fecha_operacion
                  )
                  db.session.add(historico)
                  db.session.delete(manzana)

          layer.ResetReading()
          feature = layer.GetNextFeature()
          while feature is not None:
              geometry = feature.GetGeometryRef()
              if geometry is not None:
                  geometry.FlattenTo2D()
              wkt_geom = geometry.ExportToWkt() if geometry else None

              area = geometry.GetArea() if geometry else None
              perimeter = geometry.Length() if geometry else None

              sector_val = (feature.GetField(sector_field) or "").strip()
              manzana_val = (feature.GetField(manzana_field) or "").strip()

              nuevo = Manzana(
                  id_ubigeo=ID_UBIGEO,
                  cod_sector=sector_val,
                  id_sector=f"{ID_UBIGEO}{sector_val}",
                  cod_mzna=manzana_val,
                  id_mzna=f"{ID_UBIGEO}{sector_val}{manzana_val}",
                  area_grafi=area,
                  peri_grafi=perimeter,
                  usuario_crea=id_usuario,
                  fecha_crea=fecha_operacion,
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