from datetime import datetime
from pathlib import Path

from flask import Blueprint, current_app, jsonify, request
from sqlalchemy import select

from app.extensions import db
from app.models import EjeVia, EjeViaHistorico
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

eje_vias_bp = Blueprint("eje_vias", __name__, url_prefix='/eje_vias')

@eje_vias_bp.route("/subir_shapefile", methods=["POST"])
def subir_shapefile():
  payload, status = handle_shapefile_upload(request.files.get("file"))
  return jsonify(payload), status

@eje_vias_bp.route("/validar_shapefile", methods=["POST"])
@handle_gdal_missing
def validar_shapefile():
  payload = request.get_json(silent=True) or {}

  carpeta = payload.get("nombreCarpeta")
  codigo_sector = payload.get("codigoSector")
  codigo_via = payload.get("codigoVia")
  nombre_via = payload.get("nombreVia")
  tipo_via = payload.get("tipoVia")

  if not all([carpeta, codigo_sector, codigo_via, nombre_via, tipo_via]):
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
  via_field = find_field(layer, codigo_via)
  nombre_field = find_field(layer, nombre_via)
  tipo_field = find_field(layer, tipo_via)

  if not all([sector_field, via_field, nombre_field, tipo_field]):
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

  if not geometry_matches(layer, "LINE"):
      datasource = None
      layer = None
      return (
          jsonify(
              {
                  "estado": False,
                  "mensaje": "La capa debe contener geometrías de tipo LINESTRING",
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
      "cod_via": via_field,
      "nombre_via": nombre_field,
      "tipo_via": tipo_field,
  }

  errores, registros_vacios, contador = validate_fields(
      layer,
      field_map,
      (
          FieldSpec("cod_sector", length=2, numeric=True),
          FieldSpec("cod_via", length=6, numeric=True),
          FieldSpec("nombre_via", required=True),
          FieldSpec("tipo_via", required=True),
      ),
      "cod_via",
  )

  reporte = [
      {"codVia": cod_via, "totalRegistros": total}
      for cod_via, total in sorted(contador.items())
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

@eje_vias_bp.route("/cargar_shapefile", methods=["POST"])
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
      ("cod_sector", "cod_via", "nombre_via", "tipo_via"),
      {
          "cod_sector": "campoSector",
          "cod_via": "campoVia",
          "nombre_via": "campoNombreVia",
          "tipo_via": "campoTipoVia",
      },
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
  via_field = fields["cod_via"]
  nombre_field = fields["nombre_via"]
  tipo_field = fields["tipo_via"]

  cod_vias = set()
  layer.ResetReading()
  feature = layer.GetNextFeature()
  while feature is not None:
      via_val = (feature.GetField(via_field) or "").strip()
      if via_val:
          cod_vias.add(via_val)
      feature = layer.GetNextFeature()

  fecha_operacion = datetime.utcnow()
  historico_registros = 0
  insertados = 0

  try:
      with db.session.begin():
          if cod_vias:
              existentes = (
                  db.session.execute(
                      select(EjeVia).where(EjeVia.cod_via.in_(cod_vias))
                  )
                  .scalars()
                  .all()
              )

              historico_registros = len(existentes)

              for eje in existentes:
                  historico = EjeViaHistorico.from_eje_via(
                      eje, id_usuario, fecha_operacion
                  )
                  db.session.add(historico)
                  db.session.delete(eje)

          layer.ResetReading()
          feature = layer.GetNextFeature()
          while feature is not None:
              geometry = feature.GetGeometryRef()
              if geometry is not None:
                  geometry.FlattenTo2D()
              wkt_geom = geometry.ExportToWkt() if geometry else None

              length = geometry.Length() if geometry else None

              sector_val = (feature.GetField(sector_field) or "").strip()
              via_val = (feature.GetField(via_field) or "").strip()
              nombre_val = (feature.GetField(nombre_field) or "").strip()
              tipo_val = (feature.GetField(tipo_field) or "").strip()

              nuevo = EjeVia(
                  id_ubigeo=ID_UBIGEO,
                  id_sector=f"{ID_UBIGEO}{sector_val}",
                  id_via=f"{ID_UBIGEO}{via_val}",
                  cod_via=via_val,
                  nomb_via=nombre_val,
                  tipo_via=tipo_val,
                  peri_grafi=length,
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