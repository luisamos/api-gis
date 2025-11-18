from __future__ import annotations

import os
from pathlib import Path
from typing import Dict

from flask import Flask
from flask_cors import CORS

from .config import DB_URL, ID_UBIGEO, IS_DEV
from .extensions import db, migrate
from .routes import register_routes

def prepare_directories(base_dir: Path) -> Dict[str, str]:

  uploads_dir = Path(os.getenv("UPLOADS_DIR", base_dir / "uploads"))
  tmp_dir = Path(os.getenv("TMP_DIR", uploads_dir / "tmp"))

  uploads_dir.mkdir(parents=True, exist_ok=True)
  tmp_dir.mkdir(parents=True, exist_ok=True)

  return {
    "UPLOADS_DIR": str(uploads_dir),
    "TMP_DIR": str(tmp_dir),
  }

def create_app() -> Flask:
  app = Flask(__name__)

  base_dir = Path(__file__).resolve().parent.parent

  directories = prepare_directories(base_dir)

  app.config.update(
    SQLALCHEMY_DATABASE_URI=os.getenv("DATABASE_URL", DB_URL),
    SQLALCHEMY_TRACK_MODIFICATIONS=False,
    JSON_SORT_KEYS=False,
    ID_UBIGEO=ID_UBIGEO,
    **directories,
  )

  if IS_DEV:
    app.config["ENV"] = "Development"
    app.config["DEBUG"] = True

  db.init_app(app)
  migrate.init_app(app, db)

  register_routes(app)
  CORS(app)

  @app.shell_context_processor
  def _shell_context():  # pragma: no cover - helper for interactive shell
    return {"db": db}

  return app