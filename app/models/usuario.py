from datetime import datetime
from sqlalchemy import Sequence
from app.extensions import db

class Usuario(db.Model):
  __tablename__ = 'tf_usuarios'
  __table_args__ = {'schema': 'catastro'}

  id_usuario = db.Column(
      db.BigInteger,
      Sequence('tf_usuarios_id_usuario_seq', schema='catastro'),
      primary_key=True
  )

  codi_usuario = db.Column(db.Integer, nullable=False)
  usuario = db.Column(db.String(50), nullable=False, unique=True)
  password = db.Column(db.String(255), nullable=False)

  nombres = db.Column(db.String(50), nullable=False)
  ape_paterno = db.Column(db.String(50), nullable=False)
  ape_materno = db.Column(db.String(50), nullable=False)

  email = db.Column(db.String(50))
  fecha_creacion = db.Column(db.Date)
  fecha_cese = db.Column(db.Date)

  imagen = db.Column(db.String(200))
  estado = db.Column(db.String(1), nullable=False)

  session_id = db.Column(db.String(255))