from datetime import datetime
from geoalchemy2 import Geometry
from app.extensions import db

class ManzanaHistorico(db.Model):
  __tablename__ = "tgh_manzana"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  cod_sector = db.Column(db.String(2))
  id_sector = db.Column(db.String(8))
  cod_mzna = db.Column(db.String(3))
  id_mzna = db.Column(db.String(11))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_lote(cls, manzana, usuario_modifica, fecha_modifica):
    return cls(
      gid=manzana.gid,
      id_ubigeo=manzana.id_ubigeo,
      cod_sector=manzana.cod_sector,
      id_sector=manzana.id_sector,
      cod_mzna=manzana.cod_mzna,
      id_mzna=manzana.id_mzna,
      area_grafi=manzana.area_grafi,
      peri_grafi=manzana.peri_grafi,
      usuario_crea=manzana.usuario_crea,
      fecha_crea=manzana.fecha_crea,
      geom=manzana.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )
