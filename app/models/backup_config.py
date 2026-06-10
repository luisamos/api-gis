from datetime import datetime
from ..extensions import db


class BackupConfig(db.Model):
    __tablename__ = "tf_backup_config"
    __table_args__ = {"schema": "catastro"}

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ruta_destino = db.Column(db.String(500), nullable=False)
    frecuencia_tipo = db.Column(db.String(20), nullable=False)  # diario | semanal | mensual
    hora_backup = db.Column(db.Time, nullable=False)
    activo = db.Column(db.Boolean, default=True, nullable=False)
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    fecha_actualizacion = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow
    )

    def to_dict(self):
        return {
            "id": self.id,
            "ruta_destino": self.ruta_destino,
            "frecuencia_tipo": self.frecuencia_tipo,
            "hora_backup": self.hora_backup.strftime("%H:%M") if self.hora_backup else None,
            "activo": self.activo,
            "fecha_creacion": self.fecha_creacion.isoformat() if self.fecha_creacion else None,
            "fecha_actualizacion": self.fecha_actualizacion.isoformat() if self.fecha_actualizacion else None,
        }
