from datetime import datetime
from geoalchemy2 import Geometry
from app.extensions import db

class LoteHistorico(db.Model):
    __tablename__ = "tgh_lote"
    __table_args__ = {"schema": "geo"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    gid = db.Column(db.Integer)
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
    id_usuario_operacion = db.Column(db.Integer, nullable=False)
    fecha_operacion = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    @classmethod
    def from_lote(cls, lote, id_usuario, fecha_operacion):
        return cls(
            gid=lote.gid,
            cod_sector=lote.cod_sector,
            id_ubigeo=lote.id_ubigeo,
            id_sector=lote.id_sector,
            cod_mzna=lote.cod_mzna,
            id_mzna=lote.id_mzna,
            cod_lote=lote.cod_lote,
            id_lote=lote.id_lote,
            area_grafi=lote.area_grafi,
            peri_grafi=lote.peri_grafi,
            id_usuario=lote.id_usuario,
            fech_actua=lote.fech_actua,
            cuc=lote.cuc,
            geom=lote.geom,
            id_usuario_operacion=id_usuario,
            fecha_operacion=fecha_operacion,
        )
