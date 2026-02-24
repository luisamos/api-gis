from .acceso import acceso_bp
from .geodata import geodata_bp
from .lotes import lotes_bp

def register_routes(app):
  app.register_blueprint(acceso_bp)
  app.register_blueprint(geodata_bp)
  app.register_blueprint(lotes_bp)