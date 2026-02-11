# Guía de despliegue en Linux (Ubuntu 24.04 en adelante)

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
DB_NAME=mdw
DB_HOST=localhost
DB_USER=postgres
DB_PASS=tu_password
DB_PORT=5432

DEV_FRONTEND_ORIGIN=http://127.0.0.1:5173

IS_DEV= True
ID_UBIGEO = 080108
DEBUG = True

# Host para gunicorn (linux)
APP_HOST=0.0.0.0
```

## 3. Servicio systemd con gunicorn

Crea el archivo `nano /etc/systemd/system/geocatastro.service` (como `root`):

```ini
[Unit]
Description=Gunicorn - API GIS CATASTRO (Wanchaq)
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/apps/www/api-gis

# Cargar variables desde .env (debe ser legible por www-data)
EnvironmentFile=/apps/www/api-gis/.env

Environment="APP_HOST=0.0.0.0"
Environment="APP_PORT=5000"
Environment="PATH=/apps/venv/api-gis/bin"

UMask=007

ExecStart=/apps/venv/api-gis/bin/gunicorn \
  --workers 3 \
  --bind unix:/run/geocatastro/geocatastro.sock \
  --timeout 90 \
  --log-level info \
  --capture-output \
  --access-logfile /apps/www/api-gis/logs/access.log \
  --error-logfile /apps/www/api-gis/logs/error.log \
  "app:create_app()"

Restart=always

# systemd creará /run/geocatastro con estos permisos
RuntimeDirectory=geocatastro
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
```

Crear el directorio de logs:

```bash
sudo mkdir -p /apps/www/api-gis/logs
sudo chown -R www-data:www-data /apps/www/api-gis/logs
sudo chmod 755 /apps/www/api-gis/logs
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
sudo systemctl restart geocatastro
sudo systemctl status geocatastro --no-pager

sudo journalctl -u geocatastro -n 200 --no-pager

```

El servicio quedará escuchando en el socket Unix `/run/geocatastro/geocatastro.sock`.

## 4. Dar permisos a www-data en uploads/

Crear los directorios si no existen

```bash
sudo mkdir -p /apps/www/api-gis/uploads/tmp
```

Dar propiedad al usuario del servicio (www-data)

```bash
sudo chown -R www-data:www-data /apps/www/api-gis/uploads
```

Permisos razonables (rwx para dueño y grupo, r-x para otros, ajusta si quieres)

```bash
sudo chmod -R 775 /apps/www/api-gis/uploads
```

## 5. Integración con Apache (VirtualHost SSL existente)

En tu VirtualHost de `catastro.muniwanchaq.gob.pe` agrega las directivas de proxy para reenviar las peticiones hacia el puerto 5000. Antes habilita los módulos necesarios:

```bash
sudo a2enmod proxy proxy_http headers
```

```bash
sudo systemctl reload apache2
```

Dentro del bloque `<VirtualHost *:443>` añade, por ejemplo, un sub-ruta `/api-gis/` para el API:

```apache
# --- API-GIS en el puerto 5000 ---
ProxyPreserveHost On
RequestHeader set X-Forwarded-Proto "https"
ProxyPass        /api-gis/ unix:/run/geocatastro/geocatastro.sock|http://127.0.0.1/
ProxyPassReverse /api-gis/ unix:/run/geocatastro/geocatastro.sock|http://127.0.0.1/
```

Reiniciar el servicio:

```bash
sudo systemctl reload apache2
```

## 6. Verificación

1. Comprueba que gunicorn esté escuchando:
   ```bash
   sudo systemctl status geocatastro.service
   ```
   ```bash
   curl http://127.0.0.1:5000/api-gi/health  # Ajusta con la ruta real que exponga el API
   ```
2. Desde otra máquina, valida el acceso HTTPS (Apache):
   ```bash
   curl -k https://catastro.muniwanchaq.gob.pe/api-gis/
   ```

Con estos pasos la aplicación queda desplegada en Ubuntu 24.04, atendiendo internamente en el puerto 5000 y expuesta de forma segura mediante tu VirtualHost SSL en Apache.

## 7. Solución de problemas comunes

### El servicio `geocatastro.service` falla con `status=3`

`gunicorn` devuelve el código de salida `3` cuando no puede importar la aplicación WSGI. Antes de reiniciar varias veces, revisa el traceback completo:

```bash
sudo systemctl stop geocatastro.service
sudo journalctl -u geocatastro.service -n 120 --no-pager
sudo tail -n 120 /apps/www/api-gis/logs/error.log
```

Si el traceback muestra errores de importación de módulos, valida que el entorno virtual y permisos estén bien:

```bash
sudo -u www-data /apps/venv/api-gis/bin/python -c "import flask, sqlalchemy, osgeo; print('imports-ok')"
sudo chown -R www-data:www-data /apps/www/api-gis
sudo chmod 640 /apps/www/api-gis/.env
```

En muchos servidores el fallo se debe a GDAL/OGR incompleto. Comprueba lo siguiente:

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

También puedes ejecutar gunicorn manualmente con el mismo usuario del servicio para ver el error exacto en consola:

```bash
sudo -u www-data -H bash -lc 'cd /apps/www/api-gis && /apps/venv/api-gis/bin/gunicorn --workers 1 --bind 127.0.0.1:5000 --log-level debug "app:create_app()"'
```

Tras la reinstalación reinicia el servicio y revisa el log:

```bash
sudo systemctl restart geocatastro.service
journalctl -u geocatastro.service -n 50 -f
```

Los endpoints que trabajan con Shapefile ahora devuelven un mensaje claro si GDAL sigue sin estar disponible, de forma que el resto del API pueda seguir atendiendo peticiones.
