from app.extensions import db

class Ficha(db.Model):
  __tablename__ = "tf_fichas"
  __table_args__ = {"schema": "catastro"}

  id_ficha = db.Column(db.String(19), primary_key=True)
  tipo_ficha = db.Column(db.String(2))
  nume_ficha = db.Column(db.String(10))
  id_lote = db.Column(db.String(14), nullable=False)
  dc = db.Column(db.String(1))
  nume_ficha_lote = db.Column(db.String(9))
  id_declarante = db.Column(db.String(21))
  fecha_declarante = db.Column(db.Date)
  id_supervisor = db.Column(db.String(21))
  fecha_supervision = db.Column(db.Date)
  id_tecnico = db.Column(db.String(21))
  fecha_levantamiento = db.Column(db.Date)
  id_verificador = db.Column(db.String(21))
  fecha_verificacion = db.Column(db.Date)
  nume_registro = db.Column(db.String(10))
  id_uni_cat = db.Column(db.String(23), nullable=False)
  id_usuario = db.Column(db.BigInteger, nullable=False)
  fecha_grabado = db.Column(db.DateTime)
  activo = db.Column(db.String(1))