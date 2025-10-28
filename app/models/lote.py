from datetime import datetime
from sqlalchemy import Sequence
from geoalchemy2 import Geometry
from app.extensions import db

class Lote(db.Model):
  __tablename__ = "tg_lote"
  __table_args__ = {"schema": "geo"}

  gid = db.Column(
      db.Integer,
      Sequence("tg_lote_gid_seq", schema="geo"),
      primary_key=True,
      autoincrement=True,
  )
  id_ubigeo = db.Column(db.String(6))
  cod_sector = db.Column(db.String(2))
  id_sector = db.Column(db.String(8))
  cod_mzna = db.Column(db.String(3))
  id_mzna = db.Column(db.String(11))
  cod_lote = db.Column(db.String(3))
  id_lote = db.Column(db.String(14))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  cuc = db.Column(db.String(12))
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))

class LoteHistorico(db.Model):
  __tablename__ = "tgh_lote"
  __table_args__ = {"schema": "geo"}

  id = db.Column(db.Integer, primary_key=True, autoincrement=True)
  gid = db.Column(db.Integer)
  id_ubigeo = db.Column(db.String(6))
  cod_sector = db.Column(db.String(2))
  id_sector = db.Column(db.String(8))
  cod_mzna = db.Column(db.String(3))
  id_mzna = db.Column(db.String(11))
  cod_lote = db.Column(db.String(3))
  id_lote = db.Column(db.String(14))
  area_grafi = db.Column(db.Float)
  peri_grafi = db.Column(db.Float)
  cuc = db.Column(db.String(12))
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="POLYGON", srid=32719))
  usuario_modifica = db.Column(db.Integer, nullable=False)
  fecha_modifica = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

  @classmethod
  def from_lote(cls, lote, usuario_modifica, fecha_modifica):
    return cls(
      gid=lote.gid,
      id_ubigeo=lote.id_ubigeo,
      cod_sector=lote.cod_sector,
      id_sector=lote.id_sector,
      cod_mzna=lote.cod_mzna,
      id_mzna=lote.id_mzna,
      cod_lote=lote.cod_lote,
      id_lote=lote.id_lote,
      area_grafi=lote.area_grafi,
      peri_grafi=lote.peri_grafi,
      cuc=lote.cuc,
      usuario_crea=lote.usuario_crea,
      fecha_crea=lote.fecha_crea,
      geom=lote.geom,
      usuario_modifica=usuario_modifica,
      fecha_modifica=fecha_modifica,
    )