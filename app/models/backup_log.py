from datetime import datetime
from ..extensions import db


class BackupLog(db.Model):
    __tablename__ = "tf_backup_log"
    __table_args__ = {"schema": "catastro"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fecha_backup = db.Column(db.DateTime, default=datetime.utcnow)
    esquema = db.Column(db.String(20), nullable=False)  # geo | catastro
    exitoso = db.Column(db.Boolean, nullable=False)
    ruta_archivo = db.Column(db.String(500))
    mensaje = db.Column(db.Text)
    tamano_bytes = db.Column(db.BigInteger)
    duracion_segundos = db.Column(db.Float)

    def to_dict(self):
        return {
            "id": self.id,
            "fecha_backup": self.fecha_backup.isoformat() if self.fecha_backup else None,
            "esquema": self.esquema,
            "exitoso": self.exitoso,
            "ruta_archivo": self.ruta_archivo,
            "mensaje": self.mensaje,
            "tamano_bytes": self.tamano_bytes,
            "duracion_segundos": self.duracion_segundos,
        }
