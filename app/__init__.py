from pathlib import Path

from flask import Flask
from flask_cors import CORS

from app.config import DB_URL
import geoalchemy2
from app.extensions import db, migrate
from app.routes import register_routes


def create_app(is_dev: bool = True) -> Flask:
    app = Flask(__name__)

    base_dir = Path(__file__).resolve().parent.parent
    tmp_dir = base_dir / "tmp"
    uploads_dir = base_dir / "uploads"

    tmp_dir.mkdir(parents=True, exist_ok=True)
    uploads_dir.mkdir(parents=True, exist_ok=True)

    app.config.update(
        IS_DEV=is_dev,
        BASE_DIR=str(base_dir),
        TMP_DIR=str(tmp_dir),
        UPLOADS_DIR=str(uploads_dir),
        SQLALCHEMY_DATABASE_URI=DB_URL,
        SQLALCHEMY_TRACK_MODIFICATIONS=False,
    )

    if is_dev:
        print('\n🔴\t[DESAROLLO] - MDW | API-GIS\n')
        CORS(app, resources={r"/*": {"origins": "http://127.0.0.2:5173"}})
    else:
        print('\n🟢\t[PRODUCCION] - MDW | API-GIS\n')
        CORS(app)

    db.init_app(app)
    migrate.init_app(app, db)
    register_routes(app)

    return app