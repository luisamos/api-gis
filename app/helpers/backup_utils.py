from __future__ import annotations

import os
import shutil
import subprocess
import time
from pathlib import Path
from datetime import datetime


def ejecutar_backup_esquema(
    esquema: str,
    ruta_destino: str,
    db_config: dict,
    backup_dir: str,
) -> dict:
    """Ejecuta pg_dump para un esquema y copia el resultado al destino."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M")
    nombre_archivo = f"{esquema}_{timestamp}.sql"

    tmp_dir = Path(backup_dir)
    tmp_dir.mkdir(parents=True, exist_ok=True)
    ruta_tmp = str(tmp_dir / nombre_archivo)

    env = {**os.environ, "PGPASSWORD": db_config.get("password", "")}

    cmd = [
        "pg_dump",
        "-h", db_config["host"],
        "-p", str(db_config["port"]),
        "-U", db_config["user"],
        "-d", db_config["dbname"],
        f"--schema={esquema}",
        "-Fp",
        "-f", ruta_tmp,
    ]

    inicio = time.time()
    resultado = {
        "esquema": esquema,
        "exitoso": False,
        "ruta_archivo": None,
        "mensaje": None,
        "tamano_bytes": None,
        "duracion_segundos": None,
    }

    try:
        proc = subprocess.run(
            cmd,
            env=env,
            capture_output=True,
            text=True,
            timeout=600,
        )
        resultado["duracion_segundos"] = round(time.time() - inicio, 2)

        if proc.returncode != 0:
            resultado["mensaje"] = (proc.stderr[:1000] if proc.stderr else "Error desconocido en pg_dump")
            return resultado

        tamano = Path(ruta_tmp).stat().st_size

        destino_dir = Path(ruta_destino)
        destino_dir.mkdir(parents=True, exist_ok=True)
        ruta_final = str(destino_dir / nombre_archivo)
        shutil.copy2(ruta_tmp, ruta_final)

        resultado["exitoso"] = True
        resultado["ruta_archivo"] = ruta_final
        resultado["tamano_bytes"] = tamano
        resultado["mensaje"] = "Backup completado exitosamente"

    except subprocess.TimeoutExpired:
        resultado["duracion_segundos"] = round(time.time() - inicio, 2)
        resultado["mensaje"] = "Tiempo de espera agotado (>600s)"
    except FileNotFoundError:
        resultado["duracion_segundos"] = round(time.time() - inicio, 2)
        resultado["mensaje"] = "pg_dump no encontrado. Verificar que PostgreSQL está en el PATH."
    except Exception as exc:
        resultado["duracion_segundos"] = round(time.time() - inicio, 2)
        resultado["mensaje"] = str(exc)[:1000]
    finally:
        try:
            ruta_tmp_path = Path(ruta_tmp)
            if ruta_tmp_path.exists():
                ruta_tmp_path.unlink()
        except Exception:
            pass

    return resultado


def ejecutar_backup_completo(config, db_config: dict, backup_dir: str) -> list:
    """Ejecuta backup de los esquemas geo y catastro. Retorna lista de dicts de log."""
    logs = []
    for esquema in ("geo", "catastro"):
        log_data = ejecutar_backup_esquema(esquema, config.ruta_destino, db_config, backup_dir)
        logs.append(log_data)
    return logs
