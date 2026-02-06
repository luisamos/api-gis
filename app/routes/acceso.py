from __future__ import annotations

import bcrypt
import datetime
from flask import Blueprint, current_app, jsonify, request
from flask_jwt_extended import create_access_token, get_csrf_token, jwt_required, get_jwt
from sqlalchemy.exc import SQLAlchemyError

from app.extensions import db
from app.config import IS_DEV, ENV
from app.models.rol import Rol, RolPermiso
from app.models.usuario import Usuario

acceso_bp = Blueprint("acceso", __name__, url_prefix="/token")

@acceso_bp.route("/acceso", methods=["POST"], strict_slashes=False)
def acceso_visor():
  try:
    usuario = request.json.get("usuario") if request.is_json else None
    contrasena = request.json.get("contrasena") if request.is_json else None

    if ENV == "Development":
      current_app.logger.debug("🟢\tUsuario: %s", usuario)
      current_app.logger.debug("🟢\tContraseña: %s", contrasena)

    if not usuario or not contrasena:
      return jsonify({"estado": False, "msj": "Faltan datos"}), 400

    resultado = (
      db.session.query(Usuario, Rol)
      .join(
        RolPermiso,
        db.and_(
          RolPermiso.model_id == Usuario.id_usuario,
          RolPermiso.model_type == 'App\\Models\\User',
        )
      )
      .join(Rol, Rol.id == RolPermiso.role_id)
      .filter(
        Usuario.usuario == usuario,
        Rol.id == 4,
      )
      .order_by(Usuario.usuario, Rol.name)
      .first()
    )
    print(resultado)

    if not resultado:
      return jsonify({"estado": False}), 200

    usuario_db, rol_db = resultado
    if usuario_db.estado == "0":
      return jsonify({"estado": False, "msj": "Usuario deshabilitado, habilitarlo desde el módulo principal."}), 200
    if not password_matches(usuario_db.password, contrasena):
      return jsonify({"estado": False}), 200
    nombres_apellidos = " ".join(
      filtro
      for filtro in [
        usuario_db.nombres,
        usuario_db.ape_paterno,
        usuario_db.ape_materno,
      ]
      if filtro
    ).strip()

    claims = {
      "id_usuario": str(usuario_db.id_usuario),
      "id_rol": str(rol_db.id),
      "nombres_apellidos": nombres_apellidos,
      "correo_electronico": usuario_db.email,
    }

    access_token = create_access_token(
      identity=str(usuario_db.id_usuario),
      additional_claims=claims,
    )
    csrf_token = get_csrf_token(access_token)
    resp = jsonify({"estado": True, "datos": {"nombres_apellidos": nombres_apellidos, "correo_electronico": usuario_db.email}})
    if IS_DEV:
      resp.set_cookie("access_geotoken", access_token, httponly=True, secure=True, samesite="None", partitioned=True)
      resp.set_cookie("csrf_access_token", csrf_token, httponly=False, secure=True, samesite="None", partitioned=True)
    else:
      resp.set_cookie("access_geotoken", access_token, httponly=True, secure=True, samesite="Lax")
      resp.set_cookie("csrf_access_token", csrf_token, httponly=False, secure=True, samesite="Lax")
    return resp, 200
  except SQLAlchemyError as exc:
    current_app.logger.exception("🔴 Error de base de datos: %s", exc)
    return jsonify({"error": "Error de base de datos", "detalle": str(exc)}), 500
  except Exception as exc:  # pragma: no cover - fallback
    current_app.logger.exception("🔴 Error interno del servidor: %s", exc)
    return jsonify({"error": "Error interno del servidor", "detalle": str(exc)}), 500

@acceso_bp.route("/verificar/", methods=["POST"])
@jwt_required()
def verificar_expiracion():
    try:
        token_data = get_jwt()  # Obtener los datos del token
        exp_timestamp = token_data["exp"]  # Obtener la fecha de expiración (timestamp UNIX)

        # Convertir a formato de fecha
        exp_datetime = datetime.datetime.fromtimestamp(exp_timestamp, tz=datetime.UTC)
        now_datetime = datetime.datetime.now(tz=datetime.UTC)

        if now_datetime > exp_datetime:
            return jsonify({"estado": False, "mensaje": "El token ha expirado"}), 401
        else:
            return jsonify({"estado": True, "mensaje": "El token es válido", "expira_en": str(exp_datetime - now_datetime)}), 200

    except Exception as e:
        return jsonify({"estado": False, "error": str(e)}), 500

@acceso_bp.route("/salir", methods=["POST"], strict_slashes=False)
def salir():
  resp = jsonify({"estado": True, "mensaje": "Sesión cerrada"})
  if IS_DEV:
    resp.delete_cookie("access_geotoken", secure=False, samesite="None", partitioned=True)
    resp.delete_cookie("csrf_access_token", secure=False, samesite="None", partitioned=True)
  else:
    resp.delete_cookie("access_geotoken", secure=True, samesite="Lax")
    resp.delete_cookie("csrf_access_token", secure=True, samesite="Lax")
  return resp, 200

def password_matches(stored_password: str, plain_password: str) -> bool:
  if not stored_password:
    return False
  if stored_password.startswith(("$2a$", "$2b$", "$2y$")):
    try:
      return bcrypt.checkpw(
        plain_password.encode("utf-8"),
        stored_password.encode("utf-8"),
      )
    except ValueError:
      return False
  return stored_password == plain_password