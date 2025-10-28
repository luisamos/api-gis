from .lotes import lotes_bp
from .manzanas import manzanas_bp
from .sectores import sectores_bp
from .ejes_via import ejes_via_bp


def register_routes(app):
    app.register_blueprint(lotes_bp)
    app.register_blueprint(sectores_bp)
    app.register_blueprint(manzanas_bp)
    app.register_blueprint(ejes_via_bp)