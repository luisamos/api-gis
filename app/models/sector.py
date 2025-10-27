from datetime import datetime
from sqlalchemy import Sequence
from geoalchemy2 import Geometry
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