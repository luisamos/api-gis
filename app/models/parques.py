from datetime import datetime

from geoalchemy2 import Geometry
from sqlalchemy import Sequence

from app.extensions import db

class Parques(db.Model):
  __tablename__ = "tg_parques"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_parques_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  cod_parque = db.Column(db.String(2))
  id_lote = db.Column(db.String(14))
  id_parque = db.Column(db.String(22))
  nomb_parque = db.Column(db.String(50))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))

class ParquesHistorico(db.Model):
  __tablename__ = "tgh_parques"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  cod_parque = db.Column(db.String(2))
  id_lote = db.Column(db.String(14))
  id_parque = db.Column(db.String(22))
  nomb_parque = db.Column(db.String(50))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_parques(cls, p, usuario_modifica, fecha_modifica):
    return cls(
      gid = p.gid,
      id_ubigeo = p.id_ubigeo,
      cod_parque = p.cod_parque,
      id_lote = p.id_lote,
      id_parque = p.id_parque,
      nomb_parque = p.nomb_parque,
      area_grafi = p.area_grafi,
      peri_grafi = p.peri_grafi,
      usuario_crea = p.usuario_crea,
      fecha_crea = p.fecha_crea,
      geom = p.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )
