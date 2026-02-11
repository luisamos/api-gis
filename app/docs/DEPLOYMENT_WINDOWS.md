# Guía de despliegue en Windows (instalador automático)

Este documento explica el flujo recomendado para instalar **API-GIS** en Windows usando el script:

- `app/docs/install_api_gis.ps1`

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
powershell -ExecutionPolicy Bypass -File app/docs/install_api_gis.ps1 -InstallRoot "C:\apps\python\api-gis" -VenvPath "C:\apps\python\.venv" -ServiceName "geoCatastro" -PythonVersion "3.13.2" -ListenHost "0.0.0.0" -ListenPort 5000
```

## 5. Qué hace el script

1. Valida que PowerShell esté en modo administrador.
2. Verifica que exista `-InstallRoot`.
3. Verifica que exista `requirements.txt` dentro de `-InstallRoot`.
4. Instala Python si no está disponible en `py launcher`.
5. Crea/recrea el entorno virtual en `-VenvPath`.
6. Instala dependencias sin compilar GDAL desde fuente.
7. Instala GDAL desde wheel local en `app/lib`.
8. Genera `run_api_gis.bat`.
9. Descarga NSSM (si no existe) en `tools\nssm.exe`.
10. Crea o actualiza el servicio Windows usando NSSM y lo inicia.

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

- El script espera un wheel local compatible en `app/lib`.
- Si cambias versión de Python, agrega el wheel correspondiente (`cp312`, `cp313`, etc.) o usa una versión compatible con wheel disponible.

### El servicio no inicia

- Verifica puerto ocupado (`5000` por defecto).
- Revisa variables de entorno y conexión a base de datos.
- Confirma que existe `run_api_gis.bat` en `-InstallRoot`.
- Revisa logs del servicio en `C:\apps\python\api-gis\logs\api-gis-service.log` y `api-gis-service-error.log`.

## 8. Parámetros del script

- `-InstallRoot`: ruta del repositorio (obligatorio que exista y contenga `requirements.txt`).
- `-VenvPath`: ruta del entorno virtual.
- `-ServiceName`: nombre del servicio de Windows.
- `-PythonVersion`: versión de Python para instalación automática.
- `-ListenHost`: host de escucha de Waitress.
- `-ListenPort`: puerto de escucha.

## 9. Resultado esperado

Al finalizar correctamente:

- API-GIS instalado desde la ruta indicada en `-InstallRoot`.
- Entorno virtual creado en `-VenvPath`.
- Servicio Windows creado/iniciado (`-ServiceName`).
- API accesible en `http://<host>:<puerto>/`.
