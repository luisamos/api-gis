#

# API-GIS

#

API para consulta y gestión catastral, servicio para el cargado de información geográfica mediante el proceso carga masiva a la tablas geográficas desarrolladas para la visualización del catastro municipal.

## Guías de despliegue

La documentación de despliegue está separada por sistema operativo:

- **Linux (Ubuntu + systemd + Apache + Gunicorn):** `app/docs/DEPLOYMENT.md`
- **Windows (IIS/FastCGI o ejecución con Waitress):** `app/docs/DEPLOYMENT_WINDOWS.md`

> Recomendación: usa la guía correspondiente al sistema operativo del servidor para evitar errores de configuración de servicio, permisos y rutas.
