from datetime import datetime
from sqlalchemy import Sequence, UniqueConstraint

from app.extensions import db

class Rol(db.Model):
  __tablename__ = 'roles'
  __table_args__ = {'schema': 'catastro'}

  id = db.Column(db.BigInteger, primary_key=True)
  name = db.Column(db.String(255), nullable=False)
  guard_name = db.Column(db.String(255), nullable=False)

  permissions = db.relationship(
      'Permiso',
      secondary='catastro.role_has_permissions',
      backref=db.backref('roles', lazy='dynamic'),
      lazy='dynamic'
  )
  created_at = db.Column(db.DateTime)
  updated_at = db.Column(db.DateTime)

class RolPermiso(db.Model):
  __tablename__ = 'role_has_permissions'
  __table_args__ = {'schema': 'catastro'}

  permission_id = db.Column(
      db.BigInteger,
      db.ForeignKey('catastro.permissions.id', ondelete='CASCADE'),
      primary_key=True
  )

  role_id = db.Column(
      db.BigInteger,
      db.ForeignKey('catastro.roles.id', ondelete='CASCADE'),
      primary_key=True
  )

class Permiso(db.Model):
  __tablename__ = 'permissions'
  __table_args__ = (
      UniqueConstraint('name', 'guard_name', name='permissions_name_guard_name_unique'),
      {'schema': 'catastro'}
  )

  id = db.Column(
      db.BigInteger,
      Sequence('permissions_id_seq', schema='catastro'),
      primary_key=True
  )
  name = db.Column(db.String(255), nullable=False)
  description = db.Column(db.String(255), nullable=False)
  guard_name = db.Column(db.String(255), nullable=False)
  categoria = db.Column(db.String(255))
  created_at = db.Column(db.DateTime)
  updated_at = db.Column(db.DateTime)