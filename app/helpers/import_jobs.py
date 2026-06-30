"""Registro de trabajos de importación en segundo plano.

Centraliza el seguimiento del progreso de las cargas de Shapefile para que las
rutas y el worker no repitan la lógica de bloqueo/estado. Está pensado para ser
escalable y fácil de modificar: si en el futuro se cambia el almacenamiento
(p. ej. Redis para múltiples procesos), basta con reimplementar esta clase
manteniendo la misma interfaz pública.
"""

from __future__ import annotations

import threading
import time
from typing import Dict, Optional

# Estados posibles de un trabajo (evita "strings mágicos" dispersos).
ESTADO_PROCESANDO = "procesando"
ESTADO_COMPLETADO = "completado"
ESTADO_ERROR = "error"

ESTADOS_FINALES = frozenset({ESTADO_COMPLETADO, ESTADO_ERROR})


class ImportJobRegistry:
  """Almacén thread-safe del estado de los trabajos de importación.

  Cada trabajo expone siempre las mismas claves para que el cliente pueda
  construir una barra de progreso sin lógica condicional:
    estado, mensaje, total, procesados, insertados, historico, porcentaje.
  """

  def __init__(self, ttl_segundos: int = 3600) -> None:
    self._jobs: Dict[str, dict] = {}
    self._lock = threading.Lock()
    self._ttl = ttl_segundos

  def crear(self, job_id: str, mensaje: str = "Importación iniciada") -> None:
    with self._lock:
      self._purgar_expirados()
      self._jobs[job_id] = {
        "estado": ESTADO_PROCESANDO,
        "mensaje": mensaje,
        "total": 0,
        "procesados": 0,
        "insertados": 0,
        "historico": 0,
        "porcentaje": 0,
        "_actualizado": time.monotonic(),
      }

  def actualizar(self, job_id: str, **cambios) -> None:
    with self._lock:
      job = self._jobs.get(job_id)
      if job is None:
        return
      job.update(cambios)
      job["porcentaje"] = self._calcular_porcentaje(job)
      job["_actualizado"] = time.monotonic()

  def finalizar(
    self,
    job_id: str,
    *,
    estado: str,
    mensaje: str,
    **cambios,
  ) -> None:
    """Marca un trabajo como terminado fijando el porcentaje coherente."""
    with self._lock:
      job = self._jobs.get(job_id)
      if job is None:
        return
      job.update(cambios)
      job["estado"] = estado
      job["mensaje"] = mensaje
      job["porcentaje"] = 100 if estado == ESTADO_COMPLETADO else job.get("porcentaje", 0)
      job["_actualizado"] = time.monotonic()

  def obtener(self, job_id: str) -> Optional[dict]:
    with self._lock:
      job = self._jobs.get(job_id)
      if job is None:
        return None
      return {k: v for k, v in job.items() if not k.startswith("_")}

  # -- internos --------------------------------------------------------------

  @staticmethod
  def _calcular_porcentaje(job: dict) -> int:
    # Si el worker fijó un porcentaje explícito (por fase), se respeta.
    porcentaje = job.get("porcentaje", 0)
    total = job.get("total") or 0
    procesados = job.get("procesados") or 0
    if total > 0:
      calculado = round(procesados / total * 100)
      porcentaje = max(porcentaje, min(calculado, 100))
    return int(porcentaje)

  def _purgar_expirados(self) -> None:
    """Elimina trabajos finalizados más antiguos que el TTL.

    Evita que el diccionario crezca indefinidamente en procesos de larga vida.
    Se asume que el lock ya está tomado.
    """
    ahora = time.monotonic()
    expirados = [
      job_id
      for job_id, job in self._jobs.items()
      if job["estado"] in ESTADOS_FINALES
      and ahora - job["_actualizado"] > self._ttl
    ]
    for job_id in expirados:
      self._jobs.pop(job_id, None)


# Instancia compartida por toda la aplicación.
import_jobs = ImportJobRegistry()
