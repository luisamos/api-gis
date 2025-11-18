# Guía de despliegue en Ubuntu 24.04

Este documento describe cómo ejecutar **API-GIS** en un servidor Ubuntu 24.04 utilizando Python 3.12, `gunicorn` y Apache como proxy inverso escuchando en HTTPS (puerto 443) y reenviando las peticiones al servicio Python en el puerto 5000.

## 1. Prerrequisitos del sistema

```bash
sudo apt update
sudo apt install -y python3-venv python3-dev build-essential libpq-dev gdal-bin libgdal-dev git apache2
# Opcional pero recomendado para exponer el puerto 5000
sudo ufw allow 5000/tcp
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
APP_PORT=5000
```

> `APP_HOST` y `APP_PORT` son leídos por `app.py` cuando se utiliza el modo desarrollo y por `gunicorn` a través del servicio systemd que se describe más adelante.

## 3. Servicio systemd con gunicorn

Crea el archivo `/etc/systemd/system/geocatastro.service` (como `root`):

```ini
[Unit]
Description=Gunicorn - API GIS CATASTRO (Wanchaq)
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/apps/www/api-gis
EnvironmentFile=/apps/www/api-gis/.env
Environment="APP_HOST=0.0.0.0"
Environment="APP_PORT=5000"
Environment="PATH=/apps/venv/api-gis/bin"

UMask=007
ExecStart=/apps/venv/api-gis/bin/gunicorn \
  --workers 3 \
  --bind unix:/run/geocatastro/geocatastro.sock \
  --timeout 90 \
  "app:create_app()"

Restart=always
RuntimeDirectory=api-gis
RuntimeDirectoryModce=0755

[Install]
WantedBy=multi-user.target
```

Activa el servicio:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now geocatastro.service
sudo systemctl status geocatastro.service
```

Si presenta algún error:

```bash
sudo systemctl stop geocatastro
sudo rm -f /run/geocatastro.sock /run/geocatastro/geocatastro.sock 2>/dev/null
sudo systemctl start geocatastro
sudo systemctl status geocatastro --no-pager

sudo journalctl -u geocatastro -f
```

El servicio quedará escuchando en `http://127.0.0.1:5000/` (o en la IP del servidor si abres el puerto).

## 4. Integración con Apache (VirtualHost SSL existente)

En tu VirtualHost de `catastro.muniwanchaq.gob.pe` agrega las directivas de proxy para reenviar las peticiones hacia el puerto 5000. Antes habilita los módulos necesarios:

```bash
sudo a2enmod proxy proxy_http headers
sudo systemctl reload apache2
```

Dentro del bloque `<VirtualHost *:443>` añade, por ejemplo, un sub-ruta `/api-gis/` para el API:

```apache
# --- API-GIS en el puerto 5000 ---
ProxyPreserveHost On
RequestHeader set X-Forwarded-Proto "https"
ProxyPass        /api-gis/ http://127.0.0.1:5000/
ProxyPassReverse /api-gis/ http://127.0.0.1:5000/
```

Si prefieres exponer todo el VirtualHost directamente al API, cambia `DocumentRoot` por `ProxyPass / http://127.0.0.1:5000/`. Después de editar, recarga Apache:

```bash
sudo systemctl reload apache2
```

## 5. Verificación

1. Comprueba que gunicorn esté escuchando:
   ```bash
   sudo systemctl status geocatastro.service
   curl http://127.0.0.1:5000/health  # Ajusta con la ruta real que exponga el API
   ```
2. Desde otra máquina, valida el acceso HTTPS (Apache):
   ```bash
   curl -k https://catastro.muniwanchaq.gob.pe/api-gis/
   ```

Con estos pasos la aplicación queda desplegada en Ubuntu 24.04, atendiendo internamente en el puerto 5000 y expuesta de forma segura mediante tu VirtualHost SSL en Apache.

## 6. Solución de problemas comunes

### El servicio `geocatastro.service` falla con `status=3`

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
pip install --no-cache-dir --force-reinstall gdal==3.8.4
```

Tras la reinstalación reinicia el servicio y revisa el log:

```bash
sudo systemctl restart geocatastro.service
journalctl -u geocatastro.service -n 50 -f
```

Los endpoints que trabajan con Shapefile ahora devuelven un mensaje claro si GDAL sigue sin estar disponible, de forma que el resto del API pueda seguir atendiendo peticiones.
