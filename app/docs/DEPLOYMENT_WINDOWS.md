# Despliegue en Windows

Esta guía documenta **únicamente** el flujo del instalador automático para API-GIS en Windows.

Script utilizado:

- `app/docs/install_api_gis.ps1`

---

## 1) Estructura recomendada de carpetas (orden)

Se recomienda usar esta estructura:

- **Código fuente**: `C:\apps\python\api-gis`
- **Entorno virtual**: `C:\apps\python\.venv`

> Esta estructura ya viene como valor por defecto en el instalador.

---

## 2) Qué hace el instalador

Al ejecutarlo como administrador, el script:

1. Valida permisos de administrador.
2. Verifica que exista la carpeta del proyecto y `requirements.txt`.
3. Instala Python silenciosamente si no existe `py` (Python Launcher).
4. Crea el entorno virtual en `-VenvPath` (si no existe).
5. Instala dependencias (sin compilar GDAL desde fuente).
6. Instala GDAL desde wheel local en `app/lib` compatible con la versión de Python.
7. Genera `run_api_gis.bat` para levantar la app con Waitress.
8. Crea (o actualiza) un servicio de Windows con inicio automático.
9. Inicia el servicio y deja listo el despliegue.

---

## 3) Prerrequisitos antes de ejecutar

1. Copiar el proyecto API-GIS en `C:\apps\python\api-gis`.
2. Confirmar que exista `requirements.txt` en esa ruta.
3. Abrir **PowerShell como Administrador**.
4. Validar variables de entorno/configuración de base de datos (si aplica).

---

## 4) Ejecución paso a paso

### Paso 1. Abrir PowerShell como administrador

Inicia una consola PowerShell con privilegios de administrador.

### Paso 2. Permitir ejecución de scripts en la sesión actual

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### Paso 3. Ingresamos a la carpeta C:\apps\python\api-gis

```powershell
cd api-gis
```

### Paso 4. Ejecutar instalador

```powershell
powershell -ExecutionPolicy Bypass -File app/docs/install_api_gis.ps1 -InstallRoot "C:\apps\python\api-gis" -VenvPath "C:\apps\python\.venv" -ServiceName "geoCatastro" -PythonVersion "3.13.2" -ListenHost "0.0.0.0" -ListenPort 5000
```

### Paso 5s. Verificar creación del servicio

1. Ejecuta `services.msc`.
2. Busca el servicio configurado en `-ServiceName` (ejemplo: `geoCatastro`).
3. Verifica que esté en **Automático** y **En ejecución**.

---

## 5) Parámetros del script

- `-InstallRoot`: ruta del código fuente (debe contener `requirements.txt`).
- `-VenvPath`: ruta del entorno virtual (recomendado: `C:\apps\python\.venv`).
- `-ServiceName`: nombre interno del servicio Windows.
- `-PythonVersion`: versión de Python a descargar si no está instalado `py` (recomendado `3.13.2` para wheels actuales de GDAL).
- `-ListenHost`: host de escucha de Waitress (ejemplo: `0.0.0.0`).
- `-ListenPort`: puerto de escucha (ejemplo: `5000`).

---

## 6) Validaciones rápidas post-instalación

### Ver estado del servicio por consola

```powershell
sc.exe query geoCatastro
```

### Probar respuesta HTTP local

```powershell
curl http://127.0.0.1:5000/
```

> Ajusta nombre de servicio, host y puerto según tu configuración.

---

## 7) Solución de problemas frecuentes

- **"No se puede sobrescribir la variable Host porque es de solo lectura o constante"**
  - Ya está corregido en el script actual (usa `ListenAddress` internamente).

- **Error al instalar GDAL (`easy_install.install_wrapper_scripts` / build wheel)**
  - Ocurre cuando `pip` intenta compilar GDAL desde fuente en Windows.
  - El instalador evita ese flujo e instala GDAL desde wheel local en `app/lib`.
  - Si falta wheel para tu versión de Python (`cp312`, `cp313`, etc.), agrega el wheel correspondiente en `app/lib` o cambia `-PythonVersion`.

- **"No existe la carpeta del proyecto" / "No se encontró requirements.txt"**
  - Verifica `-InstallRoot` y que el proyecto esté completo.

- **El servicio no inicia**
  - Revisa si el puerto está ocupado.
  - Revisa configuración de base de datos/variables de entorno.
  - Confirma que exista `run_api_gis.bat` en `-InstallRoot`.

---

## 8) Resultado esperado

Al finalizar correctamente:

- API-GIS queda desplegado desde `C:\apps\python\api-gis`.
- El entorno virtual queda en `C:\apps\python\.venv`.
- El servicio queda registrado en Windows y visible en `services.msc`.
- La aplicación inicia automáticamente con el sistema.
