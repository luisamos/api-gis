from __future__ import annotations

import threading
import uuid
from dataclasses import dataclass
from datetime import datetime
from functools import lru_cache
from pathlib import Path
from typing import Callable, Dict, Iterable, Optional, Type

from flask import Blueprint, current_app, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity, verify_jwt_in_request, get_jwt
from sqlalchemy import func, select, text

from app.config import IS_DEV, SRID
from app.extensions import db
from app.helpers.import_jobs import (
  ESTADO_COMPLETADO,
  ESTADO_ERROR,
  import_jobs,
)
from app.models import (
  Sector,
  SectorHistorico,
  Manzana,
  ManzanaHistorico,
  Lote,
  LoteHistorico,
  EjeVia,
  EjeViaHistorico,
  HabilitacionUrbana,
  HabilitacionUrbanaHistorico,
  Comercio,
  ComercioHistorico,
  Construccion,
  ConstruccionHistorico,
  Parque,
  ParqueHistorico,
  Puerta,
  PuertaHistorico,
)
from app.helpers.shapefile_utils import (
  FieldSpec,
  ID_UBIGEO,
  extract_fields,
  find_field,
  find_shapefile,
  geometry_matches,
  get_layer_srid_debug,
  handle_gdal_missing,
  handle_shapefile_upload,
  load_metadata,
  open_shapefile_layer,
  describe_validation_errors,
  store_metadata,
  validate_fields,
)

@dataclass
class TableDefinition:
  name: str
  geom_keyword: str
  srid: int
  specs: Iterable[FieldSpec]
  report_key: str
  model: Type
  historico_model: Type
  delete_key: str
  builder: Callable
  record_key: str
  compare_fields: tuple
  report_transform: Optional[Callable[[Dict[str, str]], str]] = None

def get_value(feature, field_name: Optional[str]) -> str:
  if not field_name:
    return ""
  return (feature.GetField(field_name) or "").strip()

def get_area_perimetro(geometry):
    if geometry is None:
        return None, None
    geometry.FlattenTo2D()
    return geometry.GetArea(), geometry.Length()

def sector_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_sector = get_value(feature, fields.get("cod_sector"))
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Sector(
    id_ubigeo=ID_UBIGEO,
    cod_sector=cod_sector,
    id_sector=f"{ID_UBIGEO}{cod_sector}",
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def manzana_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_sector = get_value(feature, fields.get("cod_sector"))
  cod_mzna = get_value(feature, fields.get("cod_mzna"))
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Manzana(
    id_ubigeo=ID_UBIGEO,
    cod_sector=cod_sector,
    id_sector=f"{ID_UBIGEO}{cod_sector}",
    cod_mzna=cod_mzna,
    id_mzna=f"{ID_UBIGEO}{cod_sector}{cod_mzna}",
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def lote_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_sector = get_value(feature, fields.get("cod_sector"))
  cod_mzna = get_value(feature, fields.get("cod_mzna"))
  cod_lote = get_value(feature, fields.get("cod_lote"))
  cuc = get_value(feature, fields.get("cuc")) or None
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Lote(
    id_ubigeo=ID_UBIGEO,
    cod_sector=cod_sector,
    id_sector=f"{ID_UBIGEO}{cod_sector}",
    cod_mzna=cod_mzna,
    id_mzna=f"{ID_UBIGEO}{cod_sector}{cod_mzna}",
    cod_lote=cod_lote,
    id_lote=f"{ID_UBIGEO}{cod_sector}{cod_mzna}{cod_lote}",
    cuc=cuc,
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def eje_via_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  _, perimetro = get_area_perimetro(geometry)
  cod_sector = get_value(feature, fields.get("cod_sector"))
  cod_via = get_value(feature, fields.get("cod_via"))
  nombre_via = get_value(feature, fields.get("nomb_via"))

  wkt_geom = geometry.ExportToWkt() if geometry else None
  return EjeVia(
    id_ubigeo=ID_UBIGEO,
    cod_sector=cod_sector or None,
    id_sector=f"{ID_UBIGEO}{cod_sector}" if cod_sector else None,
    cod_via=cod_via,
    id_via=f"{ID_UBIGEO}{cod_via}",
    nomb_via=nombre_via,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def hab_urb_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_hab_urb = get_value(feature, fields.get("cod_hab_urb"))
  tipo_hab_urb = get_value(feature, fields.get("tipo_hab_urb")) or None
  nomb_hab_urb = get_value(feature, fields.get("nomb_hab_urb"))
  etap_hab_urb = get_value(feature, fields.get("etap_hab_urb")) or None
  expediente = get_value(feature, fields.get("expediente")) or None
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return HabilitacionUrbana(
    id_ubigeo=ID_UBIGEO,
    cod_hab_urb=cod_hab_urb,
    id_hab_urb=f"{ID_UBIGEO}{cod_hab_urb}",
    tipo_hab_urb=tipo_hab_urb,
    nomb_hab_urb=nomb_hab_urb,
    etap_hab_urb=etap_hab_urb,
    expediente=expediente,
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def comercio_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_piso = get_value(feature, fields.get("cod_piso"))
  cod_lote = get_value(feature, fields.get("cod_lote"))
  id_uni_cat = get_value(feature, fields.get("id_uni_cat"))
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Comercio(
    id_ubigeo=ID_UBIGEO,
    cod_piso=cod_piso,
    cod_lote=cod_lote,
    id_uni_cat=id_uni_cat,
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def construccion_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_piso = get_value(feature, fields.get("cod_piso"))
  id_lote = get_value(feature, fields.get("id_lote"))
  id_constru = (
      f"{id_lote}{cod_piso}" if cod_piso and id_lote else None
  )
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Construccion(
    id_ubigeo=ID_UBIGEO,
    cod_piso=cod_piso,
    id_lote=id_lote or None,
    id_constru=id_constru,
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def construccion_report_transform(values: Dict[str, str]) -> str:
  id_lote = values.get("id_lote", "")
  if len(id_lote) < 8:
    return ""
  return id_lote[6:8]


def parque_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  area, perimetro = get_area_perimetro(geometry)
  cod_parque = get_value(feature, fields.get("cod_parque"))
  id_lote = get_value(feature, fields.get("id_lote"))
  nomb_parque = get_value(feature, fields.get("nomb_parque")) or None
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Parque(
    id_ubigeo=ID_UBIGEO,
    cod_parque=cod_parque,
    id_parque=f"{ID_UBIGEO}{cod_parque}",
    id_lote=id_lote,
    nomb_parque=nomb_parque,
    area_grafi=area,
    peri_grafi=perimetro,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

def puerta_builder(feature, fields, id_usuario, fecha):
  geometry = feature.GetGeometryRef()
  cod_puerta = get_value(feature, fields.get("cod_puerta"))
  esta_puerta = get_value(feature, fields.get("esta_puerta")) or None
  tipo = get_value(feature, fields.get("tipo")) or None
  id_lote = get_value(feature, fields.get("id_lote")) or None
  wkt_geom = geometry.ExportToWkt() if geometry else None
  return Puerta(
    id_ubigeo=ID_UBIGEO,
    cod_puerta=cod_puerta,
    id_puerta=f"{ID_UBIGEO}{cod_puerta}",
    esta_puerta=esta_puerta,
    tipo=tipo,
    id_lote=id_lote,
    usuario_crea=id_usuario,
    fecha_crea=fecha,
    geom=wkt_geom,
  )

TABLE_DEFINITIONS: Dict[str, TableDefinition] = {
  "Sector": TableDefinition(
    name="Sector",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(FieldSpec("cod_sector", length=2, numeric=True),),
    report_key="cod_sector",
    model=Sector,
    historico_model=SectorHistorico,
    delete_key="cod_sector",
    builder=sector_builder,
    record_key="id_sector",
    compare_fields=("area_grafi", "peri_grafi"),
  ),
  "Manzana": TableDefinition(
    name="Manzana",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(
      FieldSpec("cod_sector", length=2, numeric=True),
      FieldSpec("cod_mzna", length=3, numeric=True),
    ),
    report_key="cod_sector",
    model=Manzana,
    historico_model=ManzanaHistorico,
    delete_key="cod_sector",
    builder=manzana_builder,
    record_key="id_mzna",
    compare_fields=("area_grafi", "peri_grafi"),
  ),
  "Lote": TableDefinition(
    name="Lote",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(
      FieldSpec("cod_sector", length=2, numeric=True),
      FieldSpec("cod_mzna", length=3, numeric=True),
      FieldSpec("cod_lote", length=3, numeric=True),
      FieldSpec("cuc", length=12, numeric=False, required=False),
    ),
    report_key="cod_sector",
    model=Lote,
    historico_model=LoteHistorico,
    delete_key="cod_sector",
    builder=lote_builder,
    record_key="id_lote",
    compare_fields=("cuc", "area_grafi", "peri_grafi"),
  ),
  "EjeVia": TableDefinition(
    name="EjeVia",
    geom_keyword="LINE",
    srid=SRID,
    specs=(
      FieldSpec("cod_sector", length=2, numeric=True, required=True),
      FieldSpec("cod_via", length=6, numeric=True),
      FieldSpec("nomb_via", required=True),
    ),
    report_key="cod_sector",
    model=EjeVia,
    historico_model=EjeViaHistorico,
    delete_key="cod_via",
    builder=eje_via_builder,
    record_key="id_via",
    compare_fields=("cod_sector", "id_sector", "nomb_via", "peri_grafi"),
  ),
  "HabilitacionUrbana": TableDefinition(
    name="HabilitacionUrbana",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(
      FieldSpec("cod_hab_urb", length=4, numeric=True),
      FieldSpec("tipo_hab_urb", required=False),
      FieldSpec("nomb_hab_urb", required=True),
    ),
    report_key="tipo_hab_urb",
    model=HabilitacionUrbana,
    historico_model=HabilitacionUrbanaHistorico,
    delete_key="cod_hab_urb",
    builder=hab_urb_builder,
    record_key="id_hab_urb",
    compare_fields=("tipo_hab_urb", "nomb_hab_urb", "etap_hab_urb", "expediente", "area_grafi", "peri_grafi"),
  ),
  "Comercio": TableDefinition(
    name="Comercio",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(
      FieldSpec("cod_piso", length=2, numeric=True),
      FieldSpec("cod_lote", length=3, numeric=True),
      FieldSpec("id_uni_cat", required=True),
    ),
    report_key="cod_lote",
    model=Comercio,
    historico_model=ComercioHistorico,
    delete_key="cod_lote",
    builder=comercio_builder,
    record_key="id_uni_cat",
    compare_fields=("cod_piso", "cod_lote", "area_grafi", "peri_grafi"),
  ),
  "Construccion": TableDefinition(
    name="Construccion",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(
      FieldSpec("cod_piso", length=2, numeric=True),
      FieldSpec("id_lote", required=True),
    ),
    report_key="id_lote",
    report_transform=construccion_report_transform,
    model=Construccion,
    historico_model=ConstruccionHistorico,
    delete_key="cod_piso",
    builder=construccion_builder,
    record_key="id_constru",
    compare_fields=("cod_piso", "id_lote", "area_grafi", "peri_grafi"),
  ),
  "Parque": TableDefinition(
    name="Parque",
    geom_keyword="POLYGON",
    srid=SRID,
    specs=(
      FieldSpec("cod_parque", length=2, numeric=True),
      FieldSpec("id_lote", required=True),
      FieldSpec("nomb_parque", required=False),
    ),
    report_key="id_lote",
    model=Parque,
    historico_model=ParqueHistorico,
    delete_key="cod_parque",
    builder=parque_builder,
    record_key="id_parque",
    compare_fields=("id_lote", "nomb_parque", "area_grafi", "peri_grafi"),
  ),
  "Puerta": TableDefinition(
    name="Puerta",
    geom_keyword="POINT",
    srid=SRID,
    specs=(
      FieldSpec("cod_puerta", length=2, numeric=True),
      FieldSpec("id_lote", required=False),
      FieldSpec("esta_puerta", required=False),
      FieldSpec("tipo", length=1, required=False),
    ),
    report_key="id_lote",
    model=Puerta,
    historico_model=PuertaHistorico,
    delete_key="cod_puerta",
    builder=puerta_builder,
    record_key="id_puerta",
    compare_fields=("esta_puerta", "tipo", "id_lote"),
  ),
}

def resolve_table(payload: dict) -> Optional[TableDefinition]:
  table_name = payload.get("tabla")
  if not table_name:
    return None
  return TABLE_DEFINITIONS.get(table_name)

def serializar_spec(spec: FieldSpec) -> dict:
  """Convierte un FieldSpec en metadatos legibles para el cliente.

  Es la fuente única de verdad de los campos obligatorios para la carga; el
  visor consume esto para construir su "manual" sin duplicar reglas.
  """
  return {
    "campo": spec.key,
    "etiqueta": spec.key.upper(),
    "obligatorio": spec.required,
    # 'numerico' es la fuente confiable (booleano); 'tipo' se mantiene por
    # compatibilidad con clientes previos.
    "numerico": spec.numeric,
    "tipo": "numerico" if spec.numeric else "texto",
    "digitos": spec.length,
    "descripcion": _descripcion_spec(spec),
  }

def _descripcion_spec(spec: FieldSpec) -> str:
  tipo = "numérico" if spec.numeric else "texto"
  if spec.length:
    detalle = f"{tipo} de {spec.length} dígito{'s' if spec.length != 1 else ''}"
  else:
    detalle = f"{tipo} (longitud variable)"
  obligatoriedad = "obligatorio" if spec.required else "opcional"
  return f"Campo {obligatoriedad}, {detalle}."

def serializar_tabla(table_def: TableDefinition) -> dict:
  return {
    "tabla": table_def.name,
    "geometria": table_def.geom_keyword,
    "srid": table_def.srid,
    "campos": [serializar_spec(spec) for spec in table_def.specs],
  }

# TABLE_DEFINITIONS es estático durante toda la vida del proceso: solo cambia
# si se modifica el código y se reinicia el servicio. Por eso la serialización
# se cachea en memoria (se calcula una única vez por nombre de tabla) en vez
# de recalcularse en cada request a /campos_tabla.
@lru_cache(maxsize=None)
def _serializar_tabla_cacheada(nombre_tabla: str) -> dict:
  return serializar_tabla(TABLE_DEFINITIONS[nombre_tabla])

@lru_cache(maxsize=1)
def _serializar_todas_las_tablas_cacheada() -> tuple:
  return tuple(_serializar_tabla_cacheada(nombre) for nombre in TABLE_DEFINITIONS)

# Cuánto tiempo puede el navegador reutilizar la respuesta sin volver a
# pedirla (además de la caché en memoria del servidor). Al ser datos
# estáticos, un valor alto es seguro; se invalida solo reiniciando el
# servicio tras un cambio de código. "private": el endpoint exige JWT, así
# que no debe guardarse en cachés compartidas (proxy/CDN) entre usuarios.
_CAMPOS_TABLA_CACHE_CONTROL = "private, max-age=86400"

def resolve_fields(layer, payload: dict, specs: Iterable[FieldSpec]):
  field_map: Dict[str, str] = {}
  missing_required = []
  for spec in specs:
    provided_name = payload.get(spec.key) or ""
    if not provided_name:
      if spec.required:
        missing_required.append(spec.key)
      continue
    field_name = find_field(layer, provided_name)
    if not field_name:
      missing_required.append(spec.key)
      continue
    field_map[spec.key] = field_name
  return field_map, missing_required

def existing_records(table_def: TableDefinition, values: set[str]):
  if not values:
    return []
  column = getattr(table_def.model, table_def.delete_key)
  return db.session.execute(select(table_def.model).where(column.in_(values))).scalars().all()

def existing_records_lightweight(table_def: TableDefinition, values: set[str]) -> list[dict]:
  """Query gid + compare_fields only — skips geometry to reduce memory usage."""
  if not values:
    return []
  model = table_def.model
  delete_col = getattr(model, table_def.delete_key)
  record_key_col = getattr(model, table_def.record_key)
  compare_cols = [getattr(model, f) for f in table_def.compare_fields]
  rows = db.session.execute(
    select(model.gid, record_key_col, *compare_cols).where(delete_col.in_(values))
  ).all()
  result = []
  for row in rows:
    d = {"gid": row[0], table_def.record_key: row[1]}
    for i, field in enumerate(table_def.compare_fields):
      d[field] = row[2 + i]
    result.append(d)
  return result

def existing_records_by_gids(table_def: TableDefinition, gids: list[int]):
  """Load full ORM objects with geometry — only for records confirmed as changed/deleted."""
  if not gids:
    return []
  return db.session.execute(
    select(table_def.model).where(table_def.model.gid.in_(gids))
  ).scalars().all()

def fields_changed(existing_dict: dict, nuevo, table_def: TableDefinition) -> bool:
  """Compare non-geometry fields only — no DB query."""
  for field in table_def.compare_fields:
    if existing_dict.get(field) != getattr(nuevo, field):
      return True
  return False

def batch_geom_unchanged(table_def: TableDefinition, pairs: list[tuple[str, str]]) -> set[str]:
  """One PostGIS query to check geometry equality for multiple records at once.

  Returns the set of record_key values whose geometry did NOT change.
  """
  if not pairs:
    return set()
  keys = [p[0] for p in pairs]
  wkts = [p[1] for p in pairs]
  table_args = getattr(table_def.model, "__table_args__", {})
  schema = table_args.get("schema", "public") if isinstance(table_args, dict) else "public"
  table_name = table_def.model.__tablename__
  sql = text(
    f"SELECT v.rk, ST_Equals(t.geom, ST_GeomFromText(v.wkt, :srid)) AS igual "
    f"FROM unnest(CAST(:keys AS text[]), CAST(:wkts AS text[])) AS v(rk, wkt) "
    f"LEFT JOIN {schema}.{table_name} t ON t.{table_def.record_key} = v.rk"
  )
  rows = db.session.execute(sql, {"keys": keys, "wkts": wkts, "srid": table_def.srid}).all()
  return {row.rk for row in rows if row.igual}

def move_to_history(existing: list, historico_model, id_usuario, fecha):
  for record in existing:
    historico = None
    if hasattr(historico_model, "from_sector"):
      historico = historico_model.from_sector(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_manzana"):
      historico = historico_model.from_manzana(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_lote"):
      historico = historico_model.from_lote(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_eje_via"):
      historico = historico_model.from_eje_via(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_comercio"):
      historico = historico_model.from_comercio(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_construccion"):
      historico = historico_model.from_construccion(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_parque"):
      historico = historico_model.from_parque(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_habilitacion_urbana"):
      historico = historico_model.from_habilitacion_urbana(record, id_usuario, fecha)
    elif hasattr(historico_model, "from_puerta"):
      historico = historico_model.from_puerta(record, id_usuario, fecha)
    if historico is not None:
      db.session.add(historico)
      db.session.delete(record)

# ---------------------------------------------------------------------------
# Background import worker
# ---------------------------------------------------------------------------

# Frecuencia (en nº de features) con la que se reporta el avance de lectura.
_LECTURA_INTERVALO_REPORTE = 250
# Banda de porcentaje reservada a la fase de lectura del shapefile.
_LECTURA_PORCENTAJE_MIN = 5
_LECTURA_PORCENTAJE_MAX = 50

def _run_import(app, job_id: str, table_def: TableDefinition, shapefile_path, fields: dict, id_usuario: int) -> None:
  with app.app_context():
    try:
      import_jobs.actualizar(job_id, mensaje="Leyendo shapefile...", porcentaje=_LECTURA_PORCENTAJE_MIN)

      datasource, layer = open_shapefile_layer(shapefile_path)
      if datasource is None or layer is None:
        import_jobs.finalizar(job_id, estado=ESTADO_ERROR, mensaje="No se pudo abrir el Shapefile")
        return

      total = layer.GetFeatureCount()
      import_jobs.actualizar(job_id, total=total)

      fecha = datetime.utcnow()
      delete_values: set[str] = set()
      incoming: Dict[str, object] = {}

      layer.ResetReading()
      feature = layer.GetNextFeature()
      leidos = 0
      while feature is not None:
        value = get_value(feature, fields.get(table_def.delete_key))
        if value:
          delete_values.add(value)
        nuevo = table_def.builder(feature, fields, id_usuario, fecha)
        key = getattr(nuevo, table_def.record_key, None)
        if key:
          incoming[key] = nuevo
        leidos += 1
        if total and leidos % _LECTURA_INTERVALO_REPORTE == 0:
          avance = _LECTURA_PORCENTAJE_MIN + round(
            leidos / total * (_LECTURA_PORCENTAJE_MAX - _LECTURA_PORCENTAJE_MIN)
          )
          import_jobs.actualizar(
            job_id,
            mensaje=f"Leyendo shapefile... ({leidos}/{total})",
            porcentaje=avance,
          )
        feature = layer.GetNextFeature()

      layer = None
      datasource = None

      import_jobs.actualizar(
        job_id,
        procesados=len(incoming),
        total=total,
        mensaje="Comparando con datos existentes...",
        porcentaje=_LECTURA_PORCENTAJE_MAX,
      )

      historico_registros = 0
      insertados = 0

      with db.session.begin():
        existing_light = existing_records_lightweight(table_def, delete_values)
        existing_map = {r[table_def.record_key]: r for r in existing_light}

        to_archive_gids: list[int] = []
        to_insert: list = []
        geom_check_pairs: list[tuple[str, str]] = []
        geom_check_key_to_gid: Dict[str, int] = {}

        for key, existing_dict in existing_map.items():
          if key not in incoming:
            to_archive_gids.append(existing_dict["gid"])
          elif fields_changed(existing_dict, incoming[key], table_def):
            to_archive_gids.append(existing_dict["gid"])
            to_insert.append(incoming[key])
          else:
            new_wkt = getattr(incoming[key], "geom", None)
            if new_wkt:
              geom_check_pairs.append((key, new_wkt))
              geom_check_key_to_gid[key] = existing_dict["gid"]

        for key in incoming:
          if key not in existing_map:
            to_insert.append(incoming[key])

        if geom_check_pairs:
          import_jobs.actualizar(
            job_id,
            mensaje=f"Verificando {len(geom_check_pairs)} geometrías...",
            porcentaje=70,
          )
          geom_unchanged = batch_geom_unchanged(table_def, geom_check_pairs)
          for pair_key, _ in geom_check_pairs:
            if pair_key not in geom_unchanged:
              to_archive_gids.append(geom_check_key_to_gid[pair_key])
              to_insert.append(incoming[pair_key])

        historico_registros = len(to_archive_gids)
        if to_archive_gids:
          import_jobs.actualizar(
            job_id,
            mensaje=f"Archivando {historico_registros} registros históricos...",
            historico=historico_registros,
            porcentaje=85,
          )
          to_archive = existing_records_by_gids(table_def, to_archive_gids)
          move_to_history(to_archive, table_def.historico_model, id_usuario, fecha)

        insertados = len(to_insert)
        if to_insert:
          import_jobs.actualizar(
            job_id,
            mensaje=f"Insertando {insertados} registros nuevos...",
            insertados=insertados,
            porcentaje=95,
          )
          db.session.add_all(to_insert)

      mensaje_final = (
        f"Carga finalizada: {insertados} registros insertados"
        f", {historico_registros} enviados al histórico"
      )
      import_jobs.finalizar(
        job_id,
        estado=ESTADO_COMPLETADO,
        mensaje=mensaje_final,
        insertados=insertados,
        historico=historico_registros,
        procesados=total,
      )

    except Exception as exc:
      current_app.logger.exception("Error en importación en segundo plano")
      import_jobs.finalizar(job_id, estado=ESTADO_ERROR, mensaje=f"Error al procesar los datos: {exc}")

# ---------------------------------------------------------------------------

geodata_bp = Blueprint("geodata", __name__, url_prefix="/")

@geodata_bp.route("/")
def inicio():
  hoy = datetime.now().strftime("%d/%m/%Y")
  return jsonify({
      "estado": True,
      "mensaje": f"API - GIS (geoCatastro) - {hoy}"
    }), 200

@geodata_bp.route("/campos_tabla", methods=["GET"])
@geodata_bp.route("/campos_tabla/<tabla>", methods=["GET"])
@jwt_required()
def campos_tabla(tabla: Optional[str] = None):
  """Devuelve los campos obligatorios/opcionales de una o todas las tablas.

  Sirve como "manual dinámico" para el visor: nombre del campo, tipo, número de
  dígitos permitidos y si es obligatorio. Se deriva de TABLE_DEFINITIONS, la
  fuente única de las reglas de carga.
  """
  _, estado = validar_token()
  if not estado:
    return jsonify({"estado": False}), 401

  if tabla is None:
    respuesta = jsonify({
      "estado": True,
      "tablas": list(_serializar_todas_las_tablas_cacheada()),
    })
    respuesta.headers["Cache-Control"] = _CAMPOS_TABLA_CACHE_CONTROL
    return respuesta, 200

  if tabla not in TABLE_DEFINITIONS:
    return jsonify({"estado": False, "mensaje": f"Tabla no reconocida: {tabla}"}), 404

  respuesta = jsonify({"estado": True, "tabla": _serializar_tabla_cacheada(tabla)})
  respuesta.headers["Cache-Control"] = _CAMPOS_TABLA_CACHE_CONTROL
  return respuesta, 200

def validar_token():
  try:
    verify_jwt_in_request()
    if IS_DEV:
      token_data = get_jwt()
      print("Token decodificado:", token_data)

    id_usuario = get_jwt_identity()
    return id_usuario, True

  except Exception as e:
    print("Error al verificar el token:", e)
    return None, False

@geodata_bp.route("/subir_shapefile", methods=["POST"])
@jwt_required()
def subir_shapefile():
  id_usuario, estado = validar_token()
  if not estado:
    return jsonify(estado), 401
  else:
    if id_usuario:
      payload, status = handle_shapefile_upload(request.files.get("file"))
      return jsonify(payload), status
    else:
      return jsonify({"estado": False, "mensaje": "ID de usuario inválido"}), 400

@geodata_bp.route("/validar_shapefile", methods=["POST"])
@handle_gdal_missing
@jwt_required()
def validar_shapefile():
  id_usuario, estado = validar_token()
  if not estado:
    return jsonify(estado), 401
  else:
    if id_usuario:
      payload = request.get_json(silent=True) or {}
      carpeta = payload.get("nombreCarpeta")
      table_def = resolve_table(payload)

      if not carpeta or table_def is None:
        return (
          jsonify(
            {
              "estado": False,
              "mensaje": "Parámetros 'nombreCarpeta' y 'tabla' son obligatorios",
            }
          ),
          400,
        )

      carpeta_path = Path(current_app.config["UPLOADS_DIR"]) / carpeta
      if not carpeta_path.exists():
        return jsonify({"estado": False, "mensaje": f"No existe la carpeta indicada: {carpeta}"}), 404

      shapefile_path = find_shapefile(carpeta_path)
      if shapefile_path is None:
        return jsonify({"estado": False, "mensaje": f"No se encontró archivo .shp en la carpeta: {carpeta}"}), 404

      datasource, layer = open_shapefile_layer(shapefile_path)
      if datasource is None or layer is None:
        return jsonify({"estado": False, "mensaje": f"No se pudo abrir el archivo Shapefile: {shapefile_path}"}), 500

      field_map, missing_required = resolve_fields(layer, payload, table_def.specs)
      if missing_required:
        datasource = None
        layer = None
        return (
          jsonify(
            {
              "estado": False,
              "mensaje": "El archivo Shapefile no contiene los campos requeridos",
              "faltantes": missing_required,
            }
          ),
          400,
        )

      if not geometry_matches(layer, table_def.geom_keyword):
        datasource = None
        layer = None
        return (
          jsonify(
            {
              "estado": False,
              "mensaje": f"La capa debe contener geometrías de tipo {table_def.geom_keyword}",
            }
          ),
          400,
        )

      srid_debug = get_layer_srid_debug(layer, expected_epsg=table_def.srid)
      srid = srid_debug.get("srid")
      if str(srid) != str(table_def.srid):
        current_app.logger.warning(
          "Validación SRID falló para tabla=%s carpeta=%s; esperado=%s obtenido=%s detalles=%s",
          table_def.name,
          carpeta,
          table_def.srid,
          srid,
          srid_debug,
        )
        datasource = None
        layer = None
        return (
          jsonify(
            {
              "estado": False,
              "mensaje": f"La proyección del Shapefile debe ser EPSG:{table_def.srid}",
              "detalles": srid_debug,
            }
          ),
          400,
        )

      specs_to_validate = [spec for spec in table_def.specs if spec.key in field_map]
      errores, registros_vacios, contador = validate_fields(
        layer, field_map, specs_to_validate, table_def.report_key, table_def.report_transform
      )

      errores_detallados = describe_validation_errors(errores, specs_to_validate)

      reporte = [
        {table_def.report_key: clave, "totalRegistros": total}
        for clave, total in sorted(contador.items())
      ]

      datasource = None
      layer = None

      if errores:
        return (
          jsonify(
            {
              "estado": False,
              "mensaje": "Se encontraron errores en los códigos del shapefile",
              "errores": errores_detallados,
              "reporte": reporte,
            }
          ),
          400,
        )

      metadata = {
        "validado": True,
        "fields": field_map,
        "tabla": table_def.name,
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

@geodata_bp.route("/cargar_shapefile", methods=["POST"])
@handle_gdal_missing
@jwt_required()
def cargar_shapefile():
  id_usuario, estado = validar_token()
  if not estado:
    return jsonify(estado), 401

  if not id_usuario:
    return jsonify({"estado": False, "mensaje": "ID de usuario inválido"}), 400

  try:
    id_usuario = int(id_usuario)
  except (TypeError, ValueError):
    return jsonify({"estado": False, "mensaje": "El parámetro 'id_usuario' debe ser numérico"}), 400

  payload = request.get_json(silent=True) or {}
  carpeta = payload.get("nombreCarpeta")
  table_def = resolve_table(payload)

  if not carpeta or table_def is None:
    return jsonify({"estado": False, "mensaje": "Parámetros 'nombreCarpeta' y 'tabla' son obligatorios"}), 400

  carpeta_path = Path(current_app.config["UPLOADS_DIR"]) / carpeta
  if not carpeta_path.exists():
    return jsonify({"estado": False, "mensaje": f"No existe la carpeta indicada: {carpeta}"}), 404

  metadata = load_metadata(carpeta_path / "validation.json")
  if metadata is None:
    return jsonify({"estado": False, "mensaje": "Debe validar el Shapefile antes de cargarlo"}), 400

  shapefile_path = find_shapefile(carpeta_path)
  if shapefile_path is None:
    return jsonify({"estado": False, "mensaje": f"No se encontró archivo .shp en la carpeta: {carpeta}"}), 404

  fields = extract_fields(metadata, table_def.specs)
  if not fields:
    return jsonify({"estado": False, "mensaje": "La información de validación es incompleta"}), 400

  job_id = str(uuid.uuid4())
  import_jobs.crear(job_id, mensaje="Importación iniciada en segundo plano")

  app = current_app._get_current_object()
  thread = threading.Thread(
    target=_run_import,
    args=(app, job_id, table_def, shapefile_path, fields, id_usuario),
    daemon=True,
  )
  thread.start()

  return jsonify({"estado": True, "jobId": job_id, "mensaje": "Importación iniciada en segundo plano"}), 202

@geodata_bp.route("/estado_carga/<job_id>", methods=["GET"])
@jwt_required()
def estado_carga(job_id):
  _, estado = validar_token()
  if not estado:
    return jsonify({"estado": False}), 401

  job = import_jobs.obtener(job_id)
  if job is None:
    return jsonify({"estado": False, "mensaje": "Trabajo no encontrado"}), 404

  return jsonify({"estado": True, "trabajo": job}), 200