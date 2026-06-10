from __future__ import annotations

import logging
import os

from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger

logger = logging.getLogger(__name__)

_scheduler: BackgroundScheduler | None = None
_app = None

JOB_ID = "backup_programado"


def init_scheduler(app):
    global _scheduler, _app
    _app = app

    # Evitar doble instancia con el reloader de Werkzeug en desarrollo
    if app.debug and os.environ.get("WERKZEUG_RUN_MAIN") != "true":
        return

    _scheduler = BackgroundScheduler(timezone="America/Lima")
    _scheduler.start()
    logger.info("Scheduler de backup iniciado")

    with app.app_context():
        try:
            from ..models.backup_config import BackupConfig
            config = BackupConfig.query.first()
            if config and config.activo:
                reprogramar_backup(config)
        except Exception as exc:
            logger.warning("No se pudo cargar config de backup al inicio: %s", exc)


def reprogramar_backup(config):
    global _scheduler
    if _scheduler is None:
        return

    if _scheduler.get_job(JOB_ID):
        _scheduler.remove_job(JOB_ID)

    if not config.activo:
        return

    hora = config.hora_backup
    frecuencia = config.frecuencia_tipo

    if frecuencia == "diario":
        trigger = CronTrigger(hour=hora.hour, minute=hora.minute, timezone="America/Lima")
    elif frecuencia == "semanal":
        trigger = CronTrigger(day_of_week="sun", hour=hora.hour, minute=hora.minute, timezone="America/Lima")
    else:  # mensual
        trigger = CronTrigger(day=1, hour=hora.hour, minute=hora.minute, timezone="America/Lima")

    _scheduler.add_job(
        func=job_backup,
        trigger=trigger,
        id=JOB_ID,
        replace_existing=True,
    )
    logger.info(
        "Backup programado: %s a las %s",
        frecuencia,
        hora.strftime("%H:%M"),
    )


def job_backup():
    global _app
    if _app is None:
        return

    with _app.app_context():
        try:
            from ..models.backup_config import BackupConfig
            from ..models.backup_log import BackupLog
            from ..helpers.backup_utils import ejecutar_backup_completo
            from ..extensions import db
            from ..config import DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME

            config = BackupConfig.query.first()
            if not config or not config.activo:
                return

            backup_dir = _app.config.get("BACKUP_DIR", "backups")
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
            logger.info("Backup automático: %d/%d esquemas exitosos", exitosos, len(logs_data))

        except Exception as exc:
            logger.exception("Error en job de backup: %s", exc)
