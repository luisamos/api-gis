from datetime import datetime

from geoalchemy2 import Geometry
from sqlalchemy import Sequence

from app.extensions import db

class Puerta(db.Model):
  __tablename__ = "tg_puerta"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_puerta_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  cod_puerta = db.Column(db.String(2))
  id_puerta = db.Column(db.String(20))
  esta_puerta = db.Column(db.String(1))
  id_lote = db.Column(db.String(14))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POINT", srid=32719))

class PuertaHistorico(db.Model):
  __tablename__ = "tgh_puerta"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  cod_puerta = db.Column(db.String(2))
  id_puerta = db.Column(db.String(20))
  esta_puerta = db.Column(db.String(1))
  id_lote = db.Column(db.String(14))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POINT", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_puerta(cls, p, usuario_modifica, fecha_modifica):
    return cls(
      gid = p.gid,
      cod_puerta = p.cod_puerta,
      id_puerta = p.id_puerta,
      esta_puerta = p.esta_puerta,
      id_lote = p.id_lote,
      area_grafi = p.area_grafi,
      peri_grafi = p.peri_grafi,
      usuario_crea = p.usuario_crea,
      fecha_crea = p.fecha_crea,
      geom = p.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )
