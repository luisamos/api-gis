from app.extensions import db

class Persona(db.Model):
  __tablename__ = "tf_personas"
  __table_args__ = {"schema": "catastro"}

  id_persona = db.Column(db.String(21), primary_key=True)
  nume_doc = db.Column(db.String(17))
  tipo_doc = db.Column(db.String(2))
  tipo_persona = db.Column(db.String(1))
  nombres = db.Column(db.String(150))
  ape_paterno = db.Column(db.String(50))
  ape_materno = db.Column(db.String(50))
  tipo_persona_juridica = db.Column(db.String(2))
  tipo_funcion = db.Column(db.String(1))
  nregistro = db.Column(db.String(7))
  razon_social = db.Column(db.String(100))