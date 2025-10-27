from .lotes import lotes_bp

def register_routes(app):
    app.register_blueprint(lotes_bp)