from .sectores import sectores_bp
from .manzanas import manzanas_bp
from .lotes import lotes_bp
from .eje_vias import eje_vias_bp


def register_routes(app):
  app.register_blueprint(sectores_bp)
  app.register_blueprint(manzanas_bp)
  app.register_blueprint(lotes_bp)
  app.register_blueprint(eje_vias_bp)