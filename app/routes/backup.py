from __future__ import annotations

from datetime import datetime, time

from flask import Blueprint, current_app, jsonify, request
from flask_jwt_extended import jwt_required
from sqlalchemy.exc import SQLAlchemyError

from ..extensions import db
from ..models.backup_config import BackupConfig
from ..models.backup_log import BackupLog

backup_bp = Blueprint("backup", __name__, url_prefix="/backup")

FRECUENCIAS_VALIDAS = {"diario", "semanal", "mensual"}


@backup_bp.get("/configuracion")
@jwt_required()
def obtener_configuracion():
    try:
        config = BackupConfig.query.first()
        if not config:
            return jsonify({"estado": True, "mensaje": "Sin configuración", "datos": {}}), 200
        return jsonify({"estado": True, "mensaje": "OK", "datos": config.to_dict()}), 200
    except SQLAlchemyError:
        current_app.logger.exception("Error al obtener config de backup")
        return jsonify({"estado": False, "mensaje": "Error al consultar configuración", "datos": {}}), 500


@backup_bp.post("/configuracion")
@jwt_required()
def guardar_configuracion():
    datos = request.get_json(silent=True) or {}

    ruta_destino = datos.get("ruta_destino", "").strip()
    frecuencia_tipo = datos.get("frecuencia_tipo", "").strip().lower()
    hora_str = datos.get("hora_backup", "").strip()
    activo = datos.get("activo", True)

    if not ruta_destino:
        return jsonify({"estado": False, "mensaje": "La ruta de destino es obligatoria", "datos": {}}), 400

    if frecuencia_tipo not in FRECUENCIAS_VALIDAS:
        return jsonify({
            "estado": False,
            "mensaje": f"Frecuencia inválida. Use: {', '.join(sorted(FRECUENCIAS_VALIDAS))}",
            "datos": {},
        }), 400

    try:
        partes = hora_str.split(":")
        hora_backup = time(int(partes[0]), int(partes[1]))
    except (ValueError, IndexError):
        return jsonify({"estado": False, "mensaje": "Formato de hora inválido. Use HH:MM", "datos": {}}), 400

    try:
        config = BackupConfig.query.first()
        if config:
            config.ruta_destino = ruta_destino
            config.frecuencia_tipo = frecuencia_tipo
            config.hora_backup = hora_backup
            config.activo = bool(activo)
            config.fecha_actualizacion = datetime.utcnow()
        else:
            config = BackupConfig(
                ruta_destino=ruta_destino,
                frecuencia_tipo=frecuencia_tipo,
                hora_backup=hora_backup,
                activo=bool(activo),
            )
            db.session.add(config)

        db.session.commit()

        from ..helpers.backup_scheduler import reprogramar_backup
        reprogramar_backup(config)

        return jsonify({"estado": True, "mensaje": "Configuración guardada", "datos": config.to_dict()}), 200

    except SQLAlchemyError:
        db.session.rollback()
        current_app.logger.exception("Error al guardar config de backup")
        return jsonify({"estado": False, "mensaje": "Error al guardar configuración", "datos": {}}), 500


@backup_bp.post("/ejecutar")
@jwt_required()
def ejecutar_backup():
    try:
        config = BackupConfig.query.first()
        if not config:
            return jsonify({"estado": False, "mensaje": "No hay configuración de backup guardada", "datos": {}}), 400

        from ..helpers.backup_utils import ejecutar_backup_completo
        from ..config import DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME

        backup_dir = current_app.config.get("BACKUP_DIR", "backups")
        db_config = {
            "host": DB_HOST,
            "port": DB_PORT,
            "user": DB_USER,
            "password": DB_PASS,
            "dbname": DB_NAME,
        }

        logs_data = ejecutar_backup_completo(config, db_config, backup_dir)

        for log_data in logs_data:
            db.session.add(BackupLog(**log_data))
        db.session.commit()

        exitosos = sum(1 for l in logs_data if l["exitoso"])
        estado = exitosos == len(logs_data)
        mensaje = f"Backup completado: {exitosos}/{len(logs_data)} esquemas exitosos"

        return jsonify({"estado": estado, "mensaje": mensaje, "datos": {"logs": logs_data}}), 200

    except SQLAlchemyError:
        db.session.rollback()
        current_app.logger.exception("Error al guardar logs de backup")
        return jsonify({"estado": False, "mensaje": "Error al registrar resultado de backup", "datos": {}}), 500
    except Exception:
        current_app.logger.exception("Error inesperado al ejecutar backup")
        return jsonify({"estado": False, "mensaje": "Error inesperado al ejecutar backup", "datos": {}}), 500


@backup_bp.get("/logs")
@jwt_required()
def obtener_logs():
    try:
        logs = (
            BackupLog.query
            .order_by(BackupLog.fecha_backup.desc())
            .limit(10)
            .all()
        )
        return jsonify({
            "estado": True,
            "mensaje": "OK",
            "datos": [l.to_dict() for l in logs],
        }), 200
    except SQLAlchemyError:
        current_app.logger.exception("Error al consultar logs de backup")
        return jsonify({"estado": False, "mensaje": "Error al consultar historial", "datos": []}), 500
