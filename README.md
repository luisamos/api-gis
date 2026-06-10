#

# API-GIS

#

API orientada a la consulta y gestión catastral, que proporciona servicios para la incorporación de información geográfica mediante procesos de carga masiva. Asimismo, integra mecanismos para el cosechamiento de datos provenientes de diversas instituciones que brindan servicios OGC o REST geoespacial.

## Guías de despliegue

La documentación de despliegue está separada por sistema operativo:

- **Linux (Ubuntu + systemd + Apache + Gunicorn):** [app/docs/DEPLOYMENT_UBUNTU.md](app/docs/DEPLOYMENT_UBUNTU.md)
- **Windows (IIS/FastCGI o ejecución con Waitress):** [app/docs/DEPLOYMENT_WINDOWS.md](app/docs/DEPLOYMENT_WINDOWS.md)

Incluye instalador automático para Windows (`scripts/windows/install_api_gis.ps1`) que instala Python (si falta), prepara el entorno y crea un servicio administrable desde `services.msc`.

> Recomendación: usa la guía correspondiente al sistema operativo del servidor para evitar errores de configuración de servicio, permisos y rutas.

## Documentación técnica

- **Conversión de capas CAD (DWG/DXF) a Shapefile en QGIS:** [app/docs/Conversion_CAD_a_Shapefile_QGIS.md](app/docs/Conversion_CAD_a_Shapefile_QGIS.md)
