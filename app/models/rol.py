from datetime import datetime
from sqlalchemy import Index, Sequence, UniqueConstraint

from app.extensions import db

class Rol(db.Model):
  __tablename__ = 'roles'
  __table_args__ = {'schema': 'catastro'}

  id = db.Column(db.BigInteger, primary_key=True)
  name = db.Column(db.String(255), nullable=False)
  guard_name = db.Column(db.String(255), nullable=False)
  created_at = db.Column(db.DateTime)
  updated_at = db.Column(db.DateTime)

class RolPermiso(db.Model):
  __tablename__ = 'model_has_roles'
  __table_args__ = (
      {'schema': 'catastro'}
  )

  role_id = db.Column(
      db.BigInteger,
      db.ForeignKey('catastro.roles.id', ondelete='CASCADE'),
      primary_key=True
  )

  model_type = db.Column(db.String(255), nullable=False, primary_key=True)
  model_id = db.Column(db.BigInteger, nullable=False, primary_key=True)