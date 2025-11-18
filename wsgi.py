"""WSGI entry point for production servers (e.g. gunicorn)."""

from app import create_app
from app.config import IS_DEV

app = create_app(is_dev=IS_DEV)