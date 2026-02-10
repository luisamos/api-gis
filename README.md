#

# API-GIS

#

API destinada a la consulta y gestión catastral, que proporciona servicios para la incorporación de información geográfica a través de procesos de carga masiva en tablas geográficas diseñadas para la visualización del catastro municipal.

## Guías de despliegue

La documentación de despliegue está separada por sistema operativo:

- **Linux (Ubuntu + systemd + Apache + Gunicorn):** `app/docs/DEPLOYMENT_UBUNTU.md`
- **Windows (IIS/FastCGI o ejecución con Waitress):** `app/docs/DEPLOYMENT_WINDOWS.md`

Incluye instalador automático para Windows (`scripts/windows/install_api_gis.ps1`) que instala Python (si falta), prepara el entorno y crea un servicio administrable desde `services.msc`.

> Recomendación: usa la guía correspondiente al sistema operativo del servidor para evitar errores de configuración de servicio, permisos y rutas.
