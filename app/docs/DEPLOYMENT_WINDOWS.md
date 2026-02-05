# Guía de despliegue en Windows Server

Este documento describe una guía base para desplegar **API-GIS** en Windows.

## Opciones recomendadas

1. **IIS + FastCGI** (entorno corporativo con administración centralizada).
2. **Servicio de Windows + Waitress** (opción simple para publicar la app Flask).

## Prerrequisitos

- Python 3.12+
- Visual C++ Build Tools (si alguna dependencia lo requiere)
- Acceso a PostgreSQL
- Variables de entorno equivalentes al archivo `.env`

## Entorno virtual e instalación

```powershell
cd C:\apps\api-gis
py -3.12 -m venv C:\apps\venv\api-gis
C:\apps\venv\api-gis\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## Variables de entorno mínimas

```powershell
setx DB_USER postgres
setx DB_PASS tu_password
setx DB_HOST 127.0.0.1
setx DB_PORT 5432
setx DB_NAME catastro
```

## Verificación rápida

```powershell
C:\apps\venv\api-gis\Scripts\python -c "from app import create_app; app=create_app(); print('ok')"
```

Si el comando imprime `ok`, la app carga correctamente y puede integrarse con IIS/FastCGI o ejecutarse con Waitress.
