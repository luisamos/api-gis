from __future__ import annotations

import logging
import os
from datetime import timedelta
from pathlib import Path
from typing import Dict

from flask import Flask
from flask_cors import CORS

from .config import DB_URL, ID_UBIGEO, IS_DEV
from .extensions import db, jwt, migrate
from .routes import register_routes

def prepare_directories(base_dir: Path) -> Dict[str, str]:

  uploads_dir = Path(os.getenv("UPLOADS_DIR", base_dir / "uploads"))
  tmp_dir = Path(os.getenv("TMP_DIR", uploads_dir / "tmp"))
  logs_dir = Path(os.getenv("LOGS_DIR", base_dir / "logs"))

  uploads_dir.mkdir(parents=True, exist_ok=True)
  tmp_dir.mkdir(parents=True, exist_ok=True)
  logs_dir.mkdir(parents=True, exist_ok=True)

  return {
    "UPLOADS_DIR": str(uploads_dir),
    "TMP_DIR": str(tmp_dir),
    "LOGS_DIR": str(logs_dir),
  }

def configure_logging():
  log_level = os.getenv("LOG_LEVEL", "INFO").upper()

  base_dir = Path(__file__).resolve().parent.parent
  logs_dir = Path(os.getenv("LOGS_DIR", base_dir / "logs"))
  logs_dir.mkdir(parents=True, exist_ok=True)
  log_file = logs_dir / "app.log"

  logging.basicConfig(
    level=log_level,
    format="%(asctime)s [%(levelname)s] %(name)s - %(message)s",
    handlers=[
      logging.StreamHandler(),
      logging.FileHandler(log_file, encoding="utf-8"),
    ],
  )

  logging.getLogger("werkzeug").setLevel(log_level)

  return log_level

def create_app() -> Flask:
  app = Flask(__name__)

  configured_level = configure_logging()
  app.logger.setLevel(configured_level)

  if(IS_DEV):
    CORS(app, resources={
      r"/api-gis/*": {
          "origins": "http://127.0.0.2:5173"
      }
    })

  base_dir = Path(__file__).resolve().parent.parent

  directories = prepare_directories(base_dir)

  app.config.update(
    SQLALCHEMY_DATABASE_URI=os.getenv("DATABASE_URL", DB_URL),
    SQLALCHEMY_TRACK_MODIFICATIONS=False,
    JSON_SORT_KEYS=False,
    ID_UBIGEO=ID_UBIGEO,
    JWT_COOKIE_SECURE=not IS_DEV,
    JWT_TOKEN_LOCATION=["cookies"],
    JWT_ACCESS_COOKIE_NAME="access_geotoken",
    JWT_ACCESS_TOKEN_EXPIRES=timedelta(minutes=30),
    JWT_REFRESH_TOKEN_EXPIRES=timedelta(days=1),
    JWT_COOKIE_CSRF_PROTECT=True,
    JWT_COOKIE_SAMESITE="Lax",
    JWT_SECRET_KEY="VSzpW2$!7FHosVi47uvJbY",
    JWT_COOKIE_HTTPONLY=True,
    **directories,
  )

  if IS_DEV:
    app.config["ENV"] = "Development"
    app.config["DEBUG"] = True

  db.init_app(app)
  migrate.init_app(app, db)
  jwt.init_app(app)

  register_routes(app)
  CORS(app)

  @app.shell_context_processor
  def _shell_context():  # pragma: no cover - helper for interactive shell
    return {"db": db}

  return app