from __future__ import annotations

from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from sqlalchemy.exc import SQLAlchemyError

from app.extensions import db
from app.models import Ficha, FichaIndividual, Lote, Persona, Titular

lotes_bp = Blueprint("lotes", __name__, url_prefix="/lotes")


@lotes_bp.route("/", methods=["POST"], strict_slashes=False)
# @jwt_required()
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
      db.session.query(
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
    "datos_personales": [
      {
        "tipo_doc": row.tipo_doc,
        "nume_doc": row.nume_doc,
        "tipo_persona": row.tipo_persona,
        "ape_paterno": row.ape_paterno,
        "ape_materno": row.ape_materno,
        "nombres": row.nombres,
        "razon_social": row.razon_social,
      }
      for row in rows
      if row.nume_doc or row.nombres or row.razon_social
    ],
  }

  return jsonify(response), 200