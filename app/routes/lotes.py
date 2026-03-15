from __future__ import annotations

from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from sqlalchemy import func, or_
from sqlalchemy.exc import SQLAlchemyError

from app.extensions import db
from app.models import Ficha, FichaIndividual, Lote, Persona, Titular

lotes_bp = Blueprint("lotes", __name__, url_prefix="/lotes")

def consulta_base_personas():
  return (
    db.session.query(
      Lote.id_lote,
      Ficha.nume_ficha.label("numero_ficha"),
      FichaIndividual.id_ficha.label("id_ficha_individual"),
      Persona.tipo_doc,
      Persona.nume_doc,
      Persona.tipo_persona,
      Persona.ape_paterno,
      Persona.ape_materno,
      Persona.nombres,
      Persona.razon_social,
    )
    .select_from(Ficha)
    .outerjoin(FichaIndividual, FichaIndividual.id_ficha == Ficha.id_ficha)
    .outerjoin(Titular, Titular.id_ficha == Ficha.id_ficha)
    .outerjoin(Persona, Persona.id_persona == Titular.id_persona)
    .outerjoin(Lote, Lote.id_lote == Ficha.id_lote)
  )

def mapear_persona(row, numerador=None):
  persona = {
    "tipo_doc": row.tipo_doc,
    "nume_doc": row.nume_doc,
    "tipo_persona": row.tipo_persona,
    "ape_paterno": row.ape_paterno,
    "ape_materno": row.ape_materno,
    "nombres": row.nombres,
    "razon_social": row.razon_social,
  }
  if numerador is not None:
    persona["numerador"] = numerador
  return persona

def clave_persona(row):
  return (
    (row.tipo_doc or "").strip(),
    (row.nume_doc or "").strip(),
    (row.tipo_persona or "").strip(),
    (row.ape_paterno or "").strip(),
    (row.ape_materno or "").strip(),
    (row.nombres or "").strip(),
    (row.razon_social or "").strip(),
  )

def personas_sin_duplicados(rows, incluir_numerador=False):
  personas = []
  vistos = set()
  for row in rows:
    if not (row.nume_doc or row.nombres or row.razon_social):
      continue

    clave = clave_persona(row)
    if clave in vistos:
      continue

    vistos.add(clave)
    numerador = len(personas) + 1 if incluir_numerador else None
    personas.append(mapear_persona(row, numerador=numerador))

  return personas

def filas_unicas(rows):
  filas = []
  vistos = set()
  for row in rows:
    clave = (row.id_lote, row.numero_ficha, row.id_ficha_individual, *clave_persona(row))
    if clave in vistos:
      continue
    vistos.add(clave)
    filas.append(row)
  return filas

@lotes_bp.route("/", methods=["POST"], strict_slashes=False)
@jwt_required()
def por_id_lote():
  data = request.get_json(silent=True) or {}
  id_lote = (data.get("idlote") or "").strip()

  if not id_lote:
    return jsonify({"estado": False, "mensaje": "El parámetro 'idlote' es obligatorio"}), 400

  try:
    lote = db.session.query(Lote.id_lote).filter(Lote.id_lote == id_lote).first()
    if lote is None:
      return jsonify({"estado": False, "mensaje": "No se encontró información para el idlote indicado"}), 404

    rows = (
      consulta_base_personas()
      .filter(Ficha.id_lote == id_lote)
      .order_by(Ficha.id_ficha.asc(), Persona.id_persona.asc())
      .all()
    )
  except SQLAlchemyError as exc:
    return jsonify({"estado": False, "mensaje": "Error consultando predio", "detalle": str(exc)}), 500

  if not rows:
    return jsonify({"estado": True, "idlote": id_lote, "numero_ficha": None, "id_ficha_individual": None, "datos_personales": []}), 200

  response = {
    "estado": True,
    "idlote": id_lote,
    "numero_ficha": rows[0].numero_ficha,
    "id_ficha_individual": rows[0].id_ficha_individual,
    "datos_personales": personas_sin_duplicados(rows, incluir_numerador=True),
  }

  return jsonify(response), 200

@lotes_bp.route("/documento", methods=["POST"], strict_slashes=False)
@jwt_required()
def por_tipo_documento():
  data = request.get_json(silent=True) or {}
  num_doc = (data.get("num_doc") or "").strip()

  if not num_doc:
    return jsonify({"estado": False, "mensaje": "El parámetro 'num_doc' es obligatorio"}), 400

  try:
    rows = (
      consulta_base_personas()
      .filter(Persona.nume_doc == num_doc)
      .order_by(Lote.id_lote.asc(), Ficha.id_ficha.asc(), Persona.id_persona.asc())
      .all()
    )
  except SQLAlchemyError as exc:
    return jsonify({"estado": False, "mensaje": "Error consultando por número de documento", "detalle": str(exc)}), 500

  return jsonify(
    {
      "estado": True,
      "num_doc": num_doc,
      "tiene_propietario": len(filas_unicas(rows)) > 0,
      "total": len(filas_unicas(rows)),
      "resultados": [
        {
          "idlote": row.id_lote,
          "numero_ficha": row.numero_ficha,
          "id_ficha_individual": row.id_ficha_individual,
          **mapear_persona(row),
        }
        for row in filas_unicas(rows)
      ],
    }
  ), 200

@lotes_bp.route("/titulares", methods=["POST"], strict_slashes=False)
@jwt_required()
def por_nombres_o_razon_social():
  data = request.get_json(silent=True) or {}
  texto = (data.get("texto") or "").strip()

  if not texto:
    return jsonify(
      {
        "estado": False,
        "mensaje": "Debe enviar 'nombres_apellidos', 'razon_social' o 'texto' para realizar la búsqueda",
      }
    ), 400

  patron = f"%{texto}%"
  nombres_completos = func.trim(
    func.concat(
      func.coalesce(Persona.nombres, ""),
      " ",
      func.coalesce(Persona.ape_paterno, ""),
      " ",
      func.coalesce(Persona.ape_materno, ""),
    )
  )

  try:
    rows = (
      consulta_base_personas()
      .filter(or_(nombres_completos.ilike(patron), Persona.razon_social.ilike(patron)))
      .order_by(Lote.id_lote.asc(), Ficha.id_ficha.asc(), Persona.id_persona.asc())
      .all()
    )
  except SQLAlchemyError as exc:
    return jsonify({"estado": False, "mensaje": "Error consultando por nombres o razón social", "detalle": str(exc)}), 500

  return jsonify(
    {
      "estado": True,
      "texto_busqueda": texto,
      "total": len(filas_unicas(rows)),
      "resultados": [
        {
          "idlote": row.id_lote,
          "numero_ficha": row.numero_ficha,
          "id_ficha_individual": row.id_ficha_individual,
          **mapear_persona(row),
        }
        for row in filas_unicas(rows)
      ],
    }
  ), 200