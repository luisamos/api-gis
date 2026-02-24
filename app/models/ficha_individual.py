from app.extensions import db

class FichaIndividual(db.Model):
  __tablename__ = "tf_fichas_individuales"
  __table_args__ = {"schema": "catastro"}

  id_ficha = db.Column(
    db.String(19),
    db.ForeignKey("catastro.tf_fichas.id_ficha", onupdate="CASCADE", ondelete="CASCADE"),
    primary_key=True,
  )
  codi_uso = db.Column(db.String(6), nullable=False)
  cont_en = db.Column(db.String(2))
  clasificacion = db.Column(db.String(4))
  area_titulo = db.Column(db.Numeric(15, 2))
  area_declarada = db.Column(db.Numeric(15, 2))
  area_verificada = db.Column(db.Numeric(15, 2))
  porc_bc_terr_legal = db.Column(db.Numeric(8, 2))
  porc_bc_terr_fisc = db.Column(db.Numeric(8, 2))
  porc_bc_const_legal = db.Column(db.Numeric(8, 2))
  porc_bc_const_fisc = db.Column(db.Numeric(8, 2))
  evaluacion = db.Column(db.String(2))
  en_colindante = db.Column(db.Numeric(7, 2))
  en_jardin_aislamiento = db.Column(db.Numeric(7, 2))
  en_area_publica = db.Column(db.Numeric(7, 2))
  en_area_intangible = db.Column(db.Numeric(7, 2))
  cond_declarante = db.Column(db.String(2))
  esta_llenado = db.Column(db.String(1))
  nume_habitantes = db.Column(db.Integer)
  nume_familias = db.Column(db.Integer)
  mantenimiento = db.Column(db.String(2))
  observaciones = db.Column(db.Text)
  estado_propiedad = db.Column(db.String(10))
  nume_ficha = db.Column(db.String(7))
  imagen_lote = db.Column(db.String(250))
  imagen_plano = db.Column(db.String(250))