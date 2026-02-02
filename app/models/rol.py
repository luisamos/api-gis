from datetime import datetime
from sqlalchemy import Sequence

from app.extensions import db

class Role(db.Model):
  __tablename__ = 'roles'
  __table_args__ = {'schema': 'catastro'}

  id = db.Column(db.BigInteger, primary_key=True)
  name = db.Column(db.String(255), nullable=False)
  guard_name = db.Column(db.String(255), nullable=False)

  permissions = db.relationship(
      'Permission',
      secondary='catastro.role_has_permissions',
      backref=db.backref('roles', lazy='dynamic'),
      lazy='dynamic'
  )

class RoleHasPermission(db.Model):
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