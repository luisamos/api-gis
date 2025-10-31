from datetime import datetime

from geoalchemy2 import Geometry
from sqlalchemy import Sequence

from app.extensions import db

class EjeVia(db.Model):
  __tablename__ = "tg_eje_via"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_eje_via_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  id_sector = db.Column(db.String(8))
  cod_via = db.Column(db.String(6))
  id_via = db.Column(db.String(12))
  nomb_via = db.Column(db.String(200))
  #tipo_via = db.Column(db.String(200))
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="LINESTRING", srid=32719))

class EjeViaHistorico(db.Model):
  __tablename__ = "tgh_eje_via"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  id_sector = db.Column(db.String(8))
  cod_via = db.Column(db.String(6))
  id_via = db.Column(db.String(12))
  nomb_via = db.Column(db.String(200))
  #tipo_via = db.Column(db.String(200))
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="LINESTRING", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_eje_via(cls, eje_via, usuario_modifica, fecha_modifica):
    return cls(
      gid=eje_via.gid,
      id_ubigeo=eje_via.id_ubigeo,
      id_sector=eje_via.id_sector,
      id_via=eje_via.id_via,
      cod_via=eje_via.cod_via,
      nomb_via=eje_via.nomb_via,
      #tipo_via=eje_via.tipo_via,
      peri_grafi=eje_via.peri_grafi,
      usuario_crea=eje_via.usuario_crea,
      fecha_crea=eje_via.fecha_crea,
      geom=eje_via.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )