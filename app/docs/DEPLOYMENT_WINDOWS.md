# Guía de despliegue en Windows

Este documento describe una guía base para desplegar **API-GIS** en Windows.

## Instalador automático (Python + servicio visible en services.msc)

Si deseas una experiencia similar a pgAdmin4 (instalar dependencias y dejar un servicio registrado), puedes usar:

`scripts/windows/install_api_gis.ps1`

Este script:

1. Valida que se ejecute como Administrador.
2. Instala Python silenciosamente si no existe el launcher `py`.
3. Crea `.venv` dentro del proyecto.
4. Instala dependencias desde `requirements.txt`.
5. Genera `run_api_gis.bat`.
6. Crea/actualiza un servicio de Windows para API-GIS usando `sc.exe`.

### Uso rápido

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
powershell -ExecutionPolicy Bypass -File scripts/windows/install_api_gis.ps1 \
  -InstallRoot "C:\apps\api-gis" \
  -ServiceName "geoCatastro" \
  -PythonVersion "3.12.7" \
  -ListenHost "0.0.0.0" \
  -ListenPort 5000
```

Luego abre `services.msc` y valida que aparezca el servicio **geoCatastro**.

> Importante: antes de iniciar la app en producción, configura las variables de entorno de base de datos (ver sección "Variables de entorno mínimas").

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
