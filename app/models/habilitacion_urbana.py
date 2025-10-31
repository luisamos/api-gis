from datetime import datetime

from geoalchemy2 import Geometry
from sqlalchemy import Sequence

from app.extensions import db

class HabilitacionUrbana(db.Model):
  __tablename__ = "tg_hab_urb"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_hab_urb_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  id_hab_urba = db.Column(db.String(10))
  cod_hab_urba = db.Column(db.String(4))
  tipo_hab_urba = db.Column(db.String(10))
  nomb_hab_urba = db.Column(db.String(200))
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="LINESTRING", srid=32719))

class HabilitacionUrbanaHistorico(db.Model):
  __tablename__ = "tgh_hab_urb"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  id_hab_urba = db.Column(db.String(10))
  cod_hab_urba = db.Column(db.String(4))
  tipo_hab_urba = db.Column(db.String(10))
  nomb_hab_urba = db.Column(db.String(200))
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_hab_urb(cls, hab_urba, usuario_modifica, fecha_modifica):
    return cls(
      gid=hab_urba.gid,
      id_ubigeo=hab_urba.id_ubigeo,
      id_hab_urba=hab_urba.id_sector,
      cod_hab_urba=hab_urba.id_via,
      tipo_hab_urba=hab_urba.cod_via,
      nomb_hab_urba=hab_urba.nomb_via,
      usuario_crea=hab_urba.usuario_crea,
      fecha_crea=hab_urba.fecha_crea,
      geom=hab_urba.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )