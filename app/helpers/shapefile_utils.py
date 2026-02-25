"""Utility helpers for working with uploaded Shapefiles."""

from __future__ import annotations

import json
import shutil
import zipfile
from collections import Counter
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Callable, Dict, Iterable, Optional, Tuple

from flask import current_app, jsonify

try:
    from osgeo import ogr
except ImportError:
    ogr = None

from functools import wraps
try:
    from pyproj import CRS
    from pyproj.exceptions import CRSError, ProjError
except ImportError:
    CRS = None

    class ProjError(Exception):
        pass

    class CRSError(ProjError):
        pass
from werkzeug.datastructures import FileStorage
from app.config import ID_UBIGEO

GDAL_ERROR_MESSAGE = (
  "Las operaciones con Shapefile requieren GDAL/OGR. "
  "Instala 'gdal-bin' y 'libgdal-dev' en el sistema y la librería de Python "
  "(pip install gdal) antes de volver a intentarlo."
)

class GDALNotAvailable(RuntimeError):
  """Exception raised when GDAL/OGR bindings are missing."""

def is_gdal_available() -> bool:
  return ogr is not None

def ensure_gdal():
  """Return the ogr module or raise *GDALNotAvailable*."""

  if ogr is None:
      raise GDALNotAvailable(GDAL_ERROR_MESSAGE)
  ogr.UseExceptions()
  return ogr

def handle_gdal_missing(view_func):
  """Flask view decorator that returns JSON when GDAL is unavailable."""

  @wraps(view_func)
  def wrapper(*args, **kwargs):
      try:
          return view_func(*args, **kwargs)
      except GDALNotAvailable as exc:
          payload = {"estado": False, "mensaje": str(exc)}
          return jsonify(payload), 500

  return wrapper

@dataclass(frozen=True)
class FieldSpec:
  """Validation rules for a Shapefile field."""

  key: str
  length: Optional[int] = None
  numeric: bool = False
  required: bool = True

def clear_directory(path: Path) -> None:
  """Remove all files and subdirectories within *path*."""

  if not path.exists():
      return

  for item in path.iterdir():
      if item.is_file():
          item.unlink()
      else:
          shutil.rmtree(item)

def ensure_work_directories() -> Tuple[Path, Path]:
  """Return (tmp_dir, uploads_dir) ensuring both exist."""

  tmp_dir = Path(current_app.config["TMP_DIR"])
  uploads_dir = Path(current_app.config["UPLOADS_DIR"])

  tmp_dir.mkdir(parents=True, exist_ok=True)
  uploads_dir.mkdir(parents=True, exist_ok=True)

  return tmp_dir, uploads_dir

def handle_shapefile_upload(file: Optional[FileStorage]) -> Tuple[Dict[str, object], int]:
  """Process the uploaded ZIP file and persist its contents.

  Returns a tuple containing the JSON-serialisable payload and the HTTP status
  code that should be used in the response.
  """

  if not file or not file.filename.lower().endswith(".zip"):
      return {"estado": False, "mensaje": "Archivo inválido"}, 400

  tmp_dir, uploads_dir = ensure_work_directories()

  clear_directory(tmp_dir)

  zip_path = tmp_dir / file.filename
  file.save(zip_path)

  try:
      with zipfile.ZipFile(zip_path, "r") as zip_ref:
          zip_ref.extractall(tmp_dir)
  except zipfile.BadZipFile:
      zip_path.unlink(missing_ok=True)
      clear_directory(tmp_dir)
      return {"estado": False, "mensaje": "El archivo ZIP está corrupto"}, 400

  zip_path.unlink(missing_ok=True)

  shapefiles = list(tmp_dir.rglob("*.shp"))
  if not shapefiles:
      clear_directory(tmp_dir)
      return (
          {
              "estado": False,
              "mensaje": "No se encontró un archivo .shp válido en el comprimido",
          },
          404,
      )

  if len(shapefiles) > 1:
      clear_directory(tmp_dir)
      return (
          {
              "estado": False,
              "mensaje": "El archivo comprimido debe contener exactamente un Shapefile",
          },
          400,
      )

  timestamp = datetime.now().strftime("%d%m%Y%H%M%S")
  final_path = uploads_dir / timestamp

  if final_path.exists():
      shutil.rmtree(final_path)
  shutil.copytree(tmp_dir, final_path)

  clear_directory(tmp_dir)

  return {
      "estado": True,
      "mensaje": "Descomprimido correctamente",
      "nombreCarpeta": timestamp,
  }, 200

def find_shapefile(directory: Path) -> Optional[Path]:
  """Locate the first ``.shp`` file within *directory*."""

  for shp_file in directory.rglob("*.shp"):
      return shp_file
  return None

def open_shapefile_layer(shapefile_path: Path):
  """Return the OGR datasource and layer for *shapefile_path*."""

  ogr_module = ensure_gdal()

  datasource = ogr_module.Open(str(shapefile_path))
  if datasource is None:
      return None, None

  return datasource, datasource.GetLayer()

def find_field(layer, target_name: str) -> Optional[str]:
  """Locate the actual field name that matches *target_name* (case-insensitive)."""

  layer_definition = layer.GetLayerDefn()
  for index in range(layer_definition.GetFieldCount()):
      field_definition = layer_definition.GetFieldDefn(index)
      if field_definition.GetName().lower() == target_name.lower():
          return field_definition.GetName()
  return None

def geometry_matches(layer, expected_keyword: str) -> bool:
  """Return ``True`` if *layer* geometry contains ``expected_keyword``."""

  ogr_module = ensure_gdal()
  geom_type = layer.GetGeomType()
  geom_name = ogr_module.GeometryTypeToName(geom_type) or ""
  return expected_keyword.upper() in geom_name.upper()

def extract_authority_code(spatial_ref) -> Optional[str]:
  """Return the first authority code available in *spatial_ref*."""

  for authority_target in (None, "PROJCS", "GEOGCS"):
      try:
          authority_name = spatial_ref.GetAuthorityName(authority_target)
          authority_code = spatial_ref.GetAuthorityCode(authority_target)
      except RuntimeError:
          continue

      if authority_name and authority_code:
          return authority_code

  return None

def get_layer_srid_debug(layer, expected_epsg: Optional[int] = None) -> Dict[str, object]:
  """Return SRID detection result and diagnostic details for *layer*."""

  debug: Dict[str, object] = {
      "srid": None,
      "steps": [],
  }

  def append_step(step: str, **extra):
      info = {"step": step}
      info.update(extra)
      debug["steps"].append(info)

  try:
      spatial_ref = layer.GetSpatialRef()
      append_step("layer.GetSpatialRef", ok=spatial_ref is not None)
  except RuntimeError as exc:
      append_step("layer.GetSpatialRef", ok=False, error=str(exc))
      return debug

  if spatial_ref is None:
      return debug

  authority_code = extract_authority_code(spatial_ref)
  append_step("extract_authority_code(original)", code=authority_code)
  if authority_code:
      debug["srid"] = authority_code
      return debug

  # Algunos .prj (especialmente exportados por ArcGIS/QGIS en Windows) no
  # incluyen AUTHORITY en el WKT. Intentamos inferirlo directamente con GDAL.
  for transform_esri_wkt in (False, True):
      step_name = "AutoIdentifyEPSG" if not transform_esri_wkt else "AutoIdentifyEPSG+MorphFromESRI"
      try:
          candidate_srs = spatial_ref.Clone()
      except (RuntimeError, AttributeError) as exc:
          append_step(step_name, ok=False, error=f"No se pudo clonar SpatialRef: {exc}")
          continue

      if transform_esri_wkt:
          try:
              candidate_srs.MorphFromESRI()
              append_step("MorphFromESRI", ok=True)
          except RuntimeError as exc:
              append_step("MorphFromESRI", ok=False, error=str(exc))
              continue

      try:
          candidate_srs.AutoIdentifyEPSG()
      except RuntimeError as exc:
          append_step(step_name, ok=False, error=str(exc))
          continue

      authority_code = extract_authority_code(candidate_srs)
      append_step(step_name, ok=True, code=authority_code)
      if authority_code:
          debug["srid"] = authority_code
          return debug

  try:
      wkt = spatial_ref.ExportToWkt()
      append_step("ExportToWkt", ok=bool(wkt), length=len(wkt or ""))
  except RuntimeError as exc:
      append_step("ExportToWkt", ok=False, error=str(exc))
      wkt = None

  if not wkt:
      return debug

  if CRS is None:
      append_step(
          "pyproj", ok=False,
          error="pyproj no está instalado; no se puede inferir EPSG desde WKT sin códigos de autoridad"
      )
      return debug

  try:
      crs = CRS.from_wkt(wkt)
      append_step("CRS.from_wkt", ok=True)
  except (CRSError, ProjError, RuntimeError, ValueError) as exc:
      append_step("CRS.from_wkt", ok=False, error=str(exc))
      return debug

  try:
      epsg_code = crs.to_epsg()
      append_step("CRS.to_epsg", code=epsg_code)
  except (CRSError, ProjError, RuntimeError, ValueError) as exc:
      append_step("CRS.to_epsg", ok=False, error=str(exc))
      return debug

  if epsg_code is not None:
      debug["srid"] = str(epsg_code)
      return debug

  if expected_epsg is not None:
      try:
          expected_crs = CRS.from_epsg(expected_epsg)
      except (CRSError, ProjError, RuntimeError, ValueError) as exc:
          append_step("CRS.from_epsg", ok=False, error=str(exc), epsg=expected_epsg)
          return debug

      try:
          same_crs = crs == expected_crs or crs.is_exact_same(expected_crs)
      except (CRSError, ProjError, RuntimeError, ValueError) as exc:
          append_step("CRS.compare_expected", ok=False, error=str(exc), epsg=expected_epsg)
          return debug

      append_step("CRS.compare_expected", ok=same_crs, epsg=expected_epsg)
      if same_crs:
          debug["srid"] = str(expected_epsg)

  return debug


def get_layer_srid(layer, expected_epsg: Optional[int] = None) -> Optional[str]:
  """Return the SRID for *layer*, falling back to *expected_epsg* when possible."""

  result = get_layer_srid_debug(layer, expected_epsg=expected_epsg)
  srid = result.get("srid")
  return str(srid) if srid is not None else None

def validate_fields(
  layer,
  field_map: Dict[str, str],
  specs: Iterable[FieldSpec],
  report_key: str,
  report_transform: Optional[Callable[[Dict[str, str]], str]] = None,
):
  """Validate the values of the fields defined in *field_map*.

  Returns a tuple ``(errores, registros_vacios, contador)`` where ``errores`` is a
  dictionary mapping field keys to invalid record identifiers (``id`` or
  ``objectid`` when present, otherwise the row index), ``registros_vacios``
  contains the indices of rows where all tracked fields are empty, and
  ``contador`` summarises the occurrences by the field indicated in
  ``report_key`` (or the value returned by ``report_transform`` when provided).
  """

  specs_list = list(specs)
  errors: Dict[str, set[int | str]] = {spec.key: set() for spec in specs_list}
  empty_records: list[int] = []
  counter: Counter[str] = Counter()

  identifier_field = find_field(layer, "id") or find_field(layer, "objectid")

  def get_identifier(feature, default: int) -> int | str:
      if not identifier_field:
          return default
      identifier_value = feature.GetField(identifier_field)
      return identifier_value if identifier_value not in (None, "") else default

  layer.ResetReading()
  feature = layer.GetNextFeature()
  index = 1

  while feature is not None:
      values: Dict[str, str] = {}
      for spec in specs_list:
          field_name = field_map[spec.key]
          value = (feature.GetField(field_name) or "").strip()
          values[spec.key] = value

      if all(not value for value in values.values()):
          empty_records.append(index)
          counter["Vacio"] += 1
          feature = layer.GetNextFeature()
          index += 1
          continue

      identifier = get_identifier(feature, index)

      for spec in specs_list:
          value = values[spec.key]
          if not value:
              if spec.required:
                  errors[spec.key].add(identifier)
              continue

          if spec.numeric and not value.isdigit():
              errors[spec.key].add(identifier)

          if spec.length is not None and len(value) != spec.length:
              errors[spec.key].add(identifier)

      report_value = (
        report_transform(values)
        if report_transform is not None
        else values.get(report_key, "")
      )
      if report_value:
          counter[report_value] += 1
      else:
          counter["Vacio"] += 1

      feature = layer.GetNextFeature()
      index += 1

  cleaned_errors = {
      key: sorted(indices, key=str) for key, indices in errors.items() if indices
  }

  return cleaned_errors, empty_records, counter


def describe_validation_errors(
  errors: Dict[str, list[int | str]], specs: Iterable[FieldSpec]
) -> Dict[str, Dict[str, object]]:
  """Return a detailed description for each entry in ``errors``.

  The resulting mapping contains the identifiers of the invalid records and a
  human-friendly message explaining what needs to be corrected.
  """

  spec_lookup = {spec.key: spec for spec in specs}

  def build_message(spec: FieldSpec | None, key: str) -> str:
    if spec is None:
      return f"Revisar los valores del campo {key}."

    requisitos: list[str] = []
    if spec.required:
      requisitos.append("no estar vacío")
    if spec.numeric:
      requisitos.append("contener solo números")
    if spec.length is not None:
      requisitos.append(f"tener {spec.length} caracteres")

    if not requisitos:
      return f"Revisar los valores del campo {spec.key}."

    if len(requisitos) == 1:
      descripcion = requisitos[0]
    else:
      descripcion = ", ".join(requisitos[:-1]) + f" y {requisitos[-1]}"

    return f"El campo {spec.key} debe {descripcion}."

  return {
    key: {"id": indices, "mensaje": build_message(spec_lookup.get(key), key)}
    for key, indices in errors.items()
  }

def load_metadata(metadata_path: Path) -> Optional[dict]:
  """Return metadata stored at *metadata_path* if it exists."""

  if not metadata_path.exists():
      return None

  try:
      return json.loads(metadata_path.read_text(encoding="utf-8"))
  except json.JSONDecodeError:
      return None

def store_metadata(metadata_path: Path, metadata: dict) -> None:
  """Persist validation *metadata* as formatted JSON."""

  metadata_path.write_text(
    json.dumps(metadata, ensure_ascii=False, indent=2), encoding="utf-8"
  )

def extract_fields(
  metadata: dict,
  specs: Iterable[FieldSpec],
  legacy_mapping: Optional[Dict[str, str]] = None,
  ) -> Optional[Dict[str, str]]:
  """Extract field mapping ensuring required fields are present.

  Optional fields are included when present in *metadata* but do not block
  extraction when absent.
  """

  fields: Dict[str, Optional[str]] = metadata.get("fields", {})
  resolved: Dict[str, Optional[str]] = {}

  for spec in specs:
      field_name = fields.get(spec.key)

      if not field_name and legacy_mapping:
          legacy_key = legacy_mapping.get(spec.key)
          if legacy_key:
              field_name = metadata.get(legacy_key)

      if not field_name:
          if spec.required:
              return None
          continue

      resolved[spec.key] = field_name

  return resolved  # type: ignore[return-value]
