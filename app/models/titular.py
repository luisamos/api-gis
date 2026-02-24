from app.extensions import db

class Titular(db.Model):
  __tablename__ = "tf_titulares"
  __table_args__ = {"schema": "catastro"}

  id_ficha = db.Column(
    db.String(19),
    db.ForeignKey("catastro.tf_fichas.id_ficha", onupdate="CASCADE", ondelete="CASCADE"),
    primary_key=True,
  )
  id_persona = db.Column(
    db.String(21),
    db.ForeignKey("catastro.tf_personas.id_persona", onupdate="CASCADE", ondelete="CASCADE"),
    primary_key=True,
  )
  form_adquisicion = db.Column(db.String(2))
  fecha_adquisicion = db.Column(db.Date)
  porc_cotitular = db.Column(db.Numeric(7, 4))
  esta_civil = db.Column(db.String(2))
  fax = db.Column(db.String(10))
  telf = db.Column(db.String(10))
  anexo = db.Column(db.String(5))
  email = db.Column(db.String(100))
  nume_titular = db.Column(db.String(20))
  codi_contribuyente = db.Column(db.String(10))
  cond_titular = db.Column(db.String(2))