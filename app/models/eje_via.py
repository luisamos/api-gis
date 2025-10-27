from datetime import datetime
from sqlalchemy import Sequence
from geoalchemy2 import Geometry
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
  id_via = db.Column(db.String(12))
  cod_via = db.Column(db.String(6))
  nomb_via = db.Column(db.String(200))
  tipo_via = db.Column(db.String(200))
  peri_grafi = db.Column(db.Float)
  usuario_crea = db.Column(db.Integer)
  fecha_crea = db.Column(db.DateTime, default=datetime.utcnow)
  geom = db.Column(Geometry(geometry_type="LINE", srid=32719))