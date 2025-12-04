from datetime import datetime

from geoalchemy2 import Geometry
from sqlalchemy import Sequence

from app.extensions import db

class Construccion(db.Model):
  __tablename__ = "tg_construccion"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_construccion_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  cod_piso = db.Column(db.String(2))
  id_constru = db.Column(db.String(20))
  id_lote = db.Column(db.String(14))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))

class ConstruccionHistorico(db.Model):
  __tablename__ = "tgh_construccion"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  cod_piso = db.Column(db.String(2))
  id_constru = db.Column(db.String(20))
  id_lote = db.Column(db.String(14))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_construccion(cls, c, usuario_modifica, fecha_modifica):
    return cls(
      gid = c.gid,
      id_ubigeo = c.id_ubigeo,
      cod_piso = c.cod_piso,
      id_constru = c.id_constru,
      id_lote = c.id_lote,
      area_grafi = c.area_grafi,
      peri_grafi = c.peri_grafi,
      usuario_crea = c.usuario_crea,
      fecha_crea = c.fecha_crea,
      geom = c.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )
