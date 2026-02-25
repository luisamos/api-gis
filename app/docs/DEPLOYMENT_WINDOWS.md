# Guía de despliegue en Windows (instalador automático)

Este documento explica el flujo recomendado para instalar **API-GIS** en Windows usando el script:

- `app/docs/install_api_gis.ps1`
- `app/docs/install_api_gis_gui.ps1`

La guía está pensada para evitar errores de rutas, por ejemplo:

- `No existe la carpeta del proyecto: C:\apps\python\api-gis`

## 1. Estructura recomendada de carpetas

Usa esta estructura base:

- **Proyecto (código):** `C:\apps\python\api-gis`
- **Entorno virtual:** `C:\apps\python\.venv`

> Importante: el valor de `-InstallRoot` debe coincidir exactamente con la carpeta real donde está el repositorio clonado y donde existe `requirements.txt`.

## 2. Prerrequisitos

1. Abrir **PowerShell como Administrador**.
2. Tener conexión a internet (para instalar Python/dependencias si faltan).
3. Contar con permisos para crear servicios de Windows.
4. Tener el proyecto en disco (clonado o copiado).
5. Instalar GDAL Core para Windows (x64) desde GISInternals:
   - https://download.gisinternals.com/sdk/downloads/release-1944-x64-gdal-3-12-1-mapserver-8-6-0/gdal-3.12.1-1944-x64-core.msi

   El instalador usa por defecto la ruta `C:\Program Files\GDAL\projlib` y registra la variable de entorno `PROJ_LIB` con ese valor.

## 3. Preparar carpeta y clonar proyecto

### Opción recomendada (desde cero)

```powershell
New-Item -ItemType Directory -Path "C:\apps\python" -Force
cd C:\apps\python
git clone https://github.com/luisamos/api-gis.git
cd C:\apps\python\api-gis
```

### Si ya tienes el proyecto en otra ruta

Si tu repositorio está en otra carpeta (por ejemplo `C:\apps\python\flask\api-gis`), debes usar esa misma ruta en `-InstallRoot`.

## 4. Ejecutar el instalador

### 4.1 Permitir ejecución de scripts (solo sesión actual)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### 4.2 Ejecución estándar (ruta recomendada)

```powershell
powershell -ExecutionPolicy Bypass -File app/docs/install_api_gis.ps1 -InstallRoot "C:\apps\python\api-gis" -VenvPath "C:\apps\python\.venv" -ServiceName "geoCatastro" -PythonVersion "3.13.2" -ListenHost "127.0.0.1" -ListenPort 5000
```

### 4.3 Ejecución con interfaz gráfica (GUI)

Si prefieres no pasar parámetros por consola, puedes usar el asistente gráfico:

```powershell
powershell -ExecutionPolicy Bypass -File app/docs/install_api_gis_gui.ps1
```

Este asistente abre una ventana para capturar los parámetros y luego ejecuta `install_api_gis.ps1` como administrador.

## 5. Qué hace el script

1. Valida que PowerShell esté en modo administrador.
2. Verifica que exista `-InstallRoot`.
3. Verifica que exista `requirements.txt` dentro de `-InstallRoot`.
4. Descarga e instala GDAL Core (MSI) si no detecta `C:\Program Files\GDAL\projlib`.
5. Registra la variable de entorno de sistema `PROJ_LIB=C:\Program Files\GDAL\projlib`.
6. Instala Python si no está disponible en `py launcher`.
7. Crea/recrea el entorno virtual en `-VenvPath`.
8. Instala dependencias sin compilar GDAL desde fuente.
9. Instala GDAL desde wheel local en `app/lib`.
10. Genera `run_api_gis.bat`.
11. Usa NSSM desde el paquete local `app/lib/nssm-2.24.zip` y lo copia en `tools\nssm.exe`.
12. Crea o actualiza el servicio Windows usando NSSM y lo inicia.

## 6. Verificaciones post-instalación

```powershell
sc.exe query geoCatastro
```

```powershell
curl http://127.0.0.1:5000/
```

También puedes abrir `services.msc` y validar que el servicio esté en **Automático** y **En ejecución**.

## 7. Solución de errores frecuentes

### Error: `No existe la carpeta del proyecto: ...`

Causa común: `-InstallRoot` no coincide con la ruta real del repositorio.

Verifica:

```powershell
Test-Path "C:\apps\python\api-gis"
Test-Path "C:\apps\python\api-gis\requirements.txt"
```

Si estás en otra ruta, corrige el comando y pasa la ruta real en `-InstallRoot`.

### Error: `No se encontró requirements.txt en api-gis`

- El proyecto está incompleto o no estás apuntando a la raíz del repositorio.
- Asegúrate de que `requirements.txt` exista en la carpeta indicada.

### Error instalando GDAL

- Verifica que el instalador MSI de GDAL Core esté disponible:
  `https://download.gisinternals.com/sdk/downloads/release-1944-x64-gdal-3-12-1-mapserver-8-6-0/gdal-3.12.1-1944-x64-core.msi`
- Confirma que exista la ruta `C:\Program Files\GDAL\projlib`.
- Confirma variable de entorno `PROJ_LIB`:

```powershell
[Environment]::GetEnvironmentVariable("PROJ_LIB", "Machine")
```

- El script espera un wheel local compatible en `app/lib`.
- Si cambias versión de Python, agrega el wheel correspondiente (`cp312`, `cp313`, etc.) o usa una versión compatible con wheel disponible.

### El servicio no inicia

- Verifica puerto ocupado (`5000` por defecto).
- Revisa variables de entorno y conexión a base de datos.
- Confirma que existe `run_api_gis.bat` en `-InstallRoot`.
- Revisa logs del servicio en `C:\apps\python\api-gis\logs\api-gis-service.log` y `api-gis-service-error.log`.
- Si en logs aparece `TypeError: create_app() takes 0 positional arguments but 2 were given`, vuelve a ejecutar el instalador para que el servicio use `wsgi:app` como entrada WSGI de Waitress.

## 8. Parámetros del script

Parámetros de `install_api_gis.ps1`:

- `-InstallRoot`: ruta del repositorio (obligatorio que exista y contenga `requirements.txt`).
- `-VenvPath`: ruta del entorno virtual.
- `-ServiceName`: nombre del servicio de Windows.
- `-PythonVersion`: versión de Python para instalación automática.
- `-ListenHost`: host de escucha de Waitress.
- `-ListenPort`: puerto de escucha.

Parámetro de `install_api_gis_gui.ps1`:

- `-InstallerScriptPath`: ruta al script principal (`install_api_gis.ps1`).

## 9. Resultado esperado

Al finalizar correctamente:

- API-GIS instalado desde la ruta indicada en `-InstallRoot`.
- Entorno virtual creado en `-VenvPath`.
- Servicio Windows creado/iniciado (`-ServiceName`).
- API accesible en `http://<host>:<puerto>/`.
