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
  cod_hab_urb = db.Column(db.String(4))
  id_hab_urb = db.Column(db.String(10))
  tipo_hab_urb = db.Column(db.String(10))
  nomb_hab_urb = db.Column(db.String(200))
  etap_hab_urb = db.Column(db.String(200))
  expediente = db.Column(db.String(500))
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))

class HabilitacionUrbanaHistorico(db.Model):
  __tablename__ = "tgh_hab_urb"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  cod_hab_urb = db.Column(db.String(4))
  id_hab_urb = db.Column(db.String(10))
  tipo_hab_urb = db.Column(db.String(10))
  nomb_hab_urb = db.Column(db.String(200))
  etap_hab_urb = db.Column(db.String(200))
  expediente = db.Column(db.String(500))
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_hab_urb(cls, hu, usuario_modifica, fecha_modifica):
    return cls(
      gid=hu.gid,
      id_ubigeo=hu.id_ubigeo,
      cod_hab_urb=hu.cod_hab_urb,
      id_hab_urb=hu.id_hab_urb,
      tipo_hab_urb=hu.tipo_hab_urb,
      nomb_hab_urb=hu.nomb_hab_urb,
      etap_hab_urb = hu.etap_hab_urb,
      expediente = hu.expediente,
      usuario_crea=hu.usuario_crea,
      fecha_crea=hu.fecha_crea,
      geom=hu.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )