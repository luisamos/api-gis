# Guía de despliegue en Ubuntu 24.04

Este documento describe cómo ejecutar **API-GIS** en un servidor Ubuntu 24.04 utilizando Python 3.12, `gunicorn` y Apache como proxy inverso escuchando en HTTPS (puerto 443) y reenviando las peticiones al servicio Python en el puerto 9101.

## 1. Prerrequisitos del sistema

```bash
sudo apt update
sudo apt install -y python3-venv python3-dev build-essential libpq-dev gdal-bin libgdal-dev git apache2
# Opcional pero recomendado para exponer el puerto 9101
sudo ufw allow 9101/tcp
```

Asegúrate de tener un usuario con permisos sobre `/apps` (en los ejemplos se usa `www-data`, pero puedes cambiarlo según tu entorno).

## 2. Obtener el código e instalar dependencias

```bash
sudo mkdir -p /apps/www
cd /apps/www
sudo git clone https://github.com/luisamos/api-gis.git
sudo chown -R $USER:$USER api-gis
cd api-gis

python3 -m venv /apps/venv/api-gis
source /apps/venv/api-gis/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Archivo `.env`

Crea un archivo `.env` en la raíz del proyecto con la configuración de la base de datos y del entorno:

```ini
DB_USER=postgres
DB_PASS=tu_password
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=catastro
# Puerto/host para gunicorn
APP_HOST=0.0.0.0
APP_PORT=9101
```

> `APP_HOST` y `APP_PORT` son leídos por `app.py` cuando se utiliza el modo desarrollo y por `gunicorn` a través del servicio systemd que se describe más adelante.

## 3. Servicio systemd con gunicorn

Crea el archivo `/etc/systemd/system/api-gis.service` (como `root`):

```ini
[Unit]
Description=API GIS (gunicorn)
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/apps/www/api-gis
Environment="APP_HOST=0.0.0.0"
Environment="APP_PORT=9101"
EnvironmentFile=/apps/www/api-gis/.env
ExecStart=/apps/venv/api-gis/bin/gunicorn \
  --workers 4 \
  --bind 0.0.0.0:9101 \
  wsgi:app
Restart=always
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
```

Activa el servicio:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now api-gis.service
sudo systemctl status api-gis.service
```

El servicio quedará escuchando en `http://127.0.0.1:9101/` (o en la IP del servidor si abres el puerto).

## 4. Integración con Apache (VirtualHost SSL existente)

En tu VirtualHost de `catastro.muniwanchaq.gob.pe` agrega las directivas de proxy para reenviar las peticiones hacia el puerto 9101. Antes habilita los módulos necesarios:

```bash
sudo a2enmod proxy proxy_http headers
sudo systemctl reload apache2
```

Dentro del bloque `<VirtualHost *:443>` añade, por ejemplo, un sub-ruta `/api-gis/` para el API:

```apache
# --- API-GIS en el puerto 9101 ---
ProxyPreserveHost On
RequestHeader set X-Forwarded-Proto "https"
ProxyPass        /api-gis/ http://127.0.0.1:9101/
ProxyPassReverse /api-gis/ http://127.0.0.1:9101/
```

Si prefieres exponer todo el VirtualHost directamente al API, cambia `DocumentRoot` por `ProxyPass / http://127.0.0.1:9101/`. Después de editar, recarga Apache:

```bash
sudo systemctl reload apache2
```

## 5. Verificación

1. Comprueba que gunicorn esté escuchando:
   ```bash
   sudo systemctl status api-gis.service
   curl http://127.0.0.1:9101/health  # Ajusta con la ruta real que exponga el API
   ```
2. Desde otra máquina, valida el acceso HTTPS (Apache):
   ```bash
   curl -k https://catastro.muniwanchaq.gob.pe/api-gis/
   ```

Con estos pasos la aplicación queda desplegada en Ubuntu 24.04, atendiendo internamente en el puerto 9101 y expuesta de forma segura mediante tu VirtualHost SSL en Apache.

## 6. Solución de problemas comunes

### El servicio `api-gis-catastro.service` falla con `status=3`

`gunicorn` devuelve el código de salida `3` cuando no puede importar la aplicación WSGI. En la mayoría de servidores ocurre porque las dependencias de GDAL/OGR no están completamente instaladas. Comprueba lo siguiente:

```bash
python3 - <<'PY'
from osgeo import ogr
print("GDAL disponible", ogr.GetUseExceptions())
PY
```

Si el comando falla, instala los paquetes del sistema y vuelve a compilar el módulo Python:

```bash
sudo apt install -y gdal-bin libgdal-dev
source /apps/venv/api-gis/bin/activate
pip install --no-cache-dir --force-reinstall gdal==3.10.2
```

Tras la reinstalación reinicia el servicio y revisa el log:

```bash
sudo systemctl restart api-gis-catastro.service
journalctl -u api-gis-catastro.service -n 50 -f
```

Los endpoints que trabajan con Shapefile ahora devuelven un mensaje claro si GDAL sigue sin estar disponible, de forma que el resto del API pueda seguir atendiendo peticiones.
