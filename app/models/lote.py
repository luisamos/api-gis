from geoalchemy2 import Geometry

from app.extensions import db


class Lote(db.Model):
    __tablename__ = "tg_lote"
    __table_args__ = {"schema": "geo"}

    gid = db.Column(db.Integer, primary_key=True)
    cod_sector = db.Column(db.String(2))
    id_ubigeo = db.Column(db.String(6))
    id_sector = db.Column(db.String(8))
    cod_mzna = db.Column(db.String(3))
    id_mzna = db.Column(db.String(11))
    cod_lote = db.Column(db.String(3))
    id_lote = db.Column(db.String(14))
    area_grafi = db.Column(db.Float)
    peri_grafi = db.Column(db.Float)
    id_usuario = db.Column(db.Integer)
    fech_actua = db.Column(db.Date)
    cuc = db.Column(db.String(12))
    geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))