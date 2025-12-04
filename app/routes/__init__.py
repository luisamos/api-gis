from .geodata import geodata_bp


def register_routes(app):
    app.register_blueprint(geodata_bp)