"""Utility helpers for working with uploaded Shapefiles."""

from __future__ import annotations

import json
import shutil
import zipfile
from collections import Counter
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Dict, Iterable, Optional, Tuple

from flask import current_app
from osgeo import ogr
from pyproj import CRS
from pyproj.exceptions import CRSError
from werkzeug.datastructures import FileStorage
from app.config import ID_UBIGEO

ogr.UseExceptions()


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

    datasource = ogr.Open(str(shapefile_path))
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

    geom_type = layer.GetGeomType()
    geom_name = ogr.GeometryTypeToName(geom_type) or ""
    return expected_keyword.upper() in geom_name.upper()


def get_layer_srid(layer, expected_epsg: Optional[int] = None) -> Optional[str]:
    """Return the SRID for *layer*, falling back to *expected_epsg* when possible."""

    try:
        spatial_ref = layer.GetSpatialRef()
    except RuntimeError:
        return None

    if spatial_ref is None:
        return None

    try:
        authority_name = spatial_ref.GetAuthorityName(None)
        authority_code = spatial_ref.GetAuthorityCode(None)
    except RuntimeError:
        authority_name = None
        authority_code = None

    if authority_name and authority_code:
        return authority_code

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


def validate_fields(layer, field_map: Dict[str, str], specs: Iterable[FieldSpec], report_key: str):
    """Validate the values of the fields defined in *field_map*.

    Returns a tuple ``(errores, registros_vacios, contador)`` where ``errores`` is a
    dictionary mapping field keys to invalid record indices, ``registros_vacios``
    contains the indices of rows where all tracked fields are empty, and
    ``contador`` summarises the occurrences by the field indicated in
    ``report_key``.
    """

    specs_list = list(specs)
    errors: Dict[str, set[int]] = {spec.key: set() for spec in specs_list}
    empty_records: list[int] = []
    counter: Counter[str] = Counter()

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

        for spec in specs_list:
            value = values[spec.key]
            if not value:
                if spec.required:
                    errors[spec.key].add(index)
                continue

            if spec.numeric and not value.isdigit():
                errors[spec.key].add(index)

            if spec.length is not None and len(value) != spec.length:
                errors[spec.key].add(index)

        report_value = values.get(report_key, "")
        if report_value:
            counter[report_value] += 1
        else:
            counter["Vacio"] += 1

        feature = layer.GetNextFeature()
        index += 1

    cleaned_errors = {
        key: sorted(indices) for key, indices in errors.items() if indices
    }

    return cleaned_errors, empty_records, counter


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
    required_keys: Iterable[str],
    legacy_mapping: Optional[Dict[str, str]] = None,
  ) -> Optional[Dict[str, str]]:
    """Extract the field mapping from *metadata* ensuring all keys exist."""

    required = list(required_keys)
    fields: Dict[str, Optional[str]] = metadata.get("fields", {})

    resolved = {key: fields.get(key) for key in required}

    if all(resolved.values()):
        return resolved  # type: ignore[return-value]

    if legacy_mapping:
        for key in required:
            if not resolved.get(key):
                legacy_key = legacy_mapping.get(key)
                if legacy_key:
                    resolved[key] = metadata.get(legacy_key)

    if all(resolved.values()):
        return resolved  # type: ignore[return-value]

    return None