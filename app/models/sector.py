from datetime import datetime

from geoalchemy2 import Geometry
from sqlalchemy import Sequence

from app.extensions import db


class Sector(db.Model):
  __tablename__ = "tg_sectores"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_sectores_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  cod_sector = db.Column(db.String(2))
  id_sector = db.Column(db.String(8))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))

class SectorHistorico(db.Model):
  __tablename__ = "tgh_sectores"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  cod_sector = db.Column(db.String(2))
  id_sector = db.Column(db.String(8))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_sector(cls, sector, usuario_modifica, fecha_modifica):
    return cls(
      gid=sector.gid,
      id_ubigeo=sector.id_ubigeo,
      cod_sector=sector.cod_sector,
      id_sector=sector.id_sector,
      area_grafi=sector.area_grafi,
      peri_grafi=sector.peri_grafi,
      usuario_crea=sector.usuario_crea,
      fecha_crea=sector.fecha_crea,
      geom=sector.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )
