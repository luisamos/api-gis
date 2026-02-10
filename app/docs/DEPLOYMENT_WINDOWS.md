# Despliegue en Windows

Esta guía documenta **únicamente** el flujo del instalador automático para API-GIS en Windows:

- Python + entorno virtual
- Dependencias instaladas automáticamente
- Servicio de Windows visible en `services.msc`

Script utilizado:

- `app/docs/install_api_gis.ps1`

---

## 1) Qué hace el instalador

Al ejecutarlo como administrador, el script:

1. Valida permisos de administrador.
2. Verifica que exista la carpeta del proyecto y `requirements.txt`.
3. Instala Python silenciosamente si no existe `py` (Python Launcher).
4. Crea `.venv` en la raíz del proyecto (si no existe).
5. Instala/actualiza dependencias del proyecto.
6. Genera `run_api_gis.bat` para levantar la app con Waitress.
7. Crea (o actualiza) un servicio de Windows con inicio automático.
8. Inicia el servicio y deja listo el despliegue.

---

## 2) Prerrequisitos antes de ejecutar

1. Tener el proyecto API-GIS ya copiado en disco, por ejemplo: `C:\apps\api-gis`.
2. Confirmar que en esa ruta exista `requirements.txt`.
3. Abrir **PowerShell como Administrador**.
4. Definir/validar variables de entorno de base de datos para la app (si aplican en tu entorno productivo).

---

## 3) Ejecución paso a paso

### Paso 1. Abrir PowerShell como administrador

Inicia una consola PowerShell con privilegios de administrador.

### Paso 2. Permitir ejecución de scripts en la sesión actual

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### Paso 3. Ejecutar instalador

```powershell
powershell -ExecutionPolicy Bypass -File app/docs/install_api_gis.ps1 \
  -InstallRoot "C:\apps\api-gis" \
  -ServiceName "geoCatastro" \
  -PythonVersion "3.12.7" \
  -ListenHost "0.0.0.0" \
  -ListenPort 5000
```

### Paso 4. Verificar creación del servicio

1. Ejecuta `services.msc`.
2. Busca el servicio con el nombre configurado en `-ServiceName` (ejemplo: `geoCatastro`).
3. Verifica que el tipo de inicio sea **Automático** y que esté en estado **En ejecución**.

---

## 4) Parámetros del script

- `-InstallRoot`: ruta donde está el proyecto API-GIS. Debe contener `requirements.txt`.
- `-ServiceName`: nombre interno del servicio Windows.
- `-PythonVersion`: versión exacta de Python a descargar si `py` no está instalado.
- `-ListenHost`: interfaz de escucha de Waitress (ejemplo: `0.0.0.0`).
- `-ListenPort`: puerto de escucha (ejemplo: `5000`).

---

## 5) Validaciones rápidas post-instalación

### Ver estado del servicio por consola

```powershell
sc.exe query geoCatastro
```

### Probar respuesta HTTP local

```powershell
curl http://127.0.0.1:5000/
```

> Ajusta nombre de servicio, host y puerto según los parámetros que usaste.

---

## 6) Solución de problemas frecuentes

- **"Este script debe ejecutarse como Administrador"**
  - Cierra la consola y vuelve a abrir PowerShell como administrador.

- **"No existe la carpeta del proyecto"**
  - Revisa el valor de `-InstallRoot`.

- **"No se encontró requirements.txt"**
  - Verifica que el proyecto esté completo en la ruta indicada.

- **El servicio no inicia**
  - Revisa si el puerto está en uso.
  - Confirma variables de entorno/configuración de base de datos.
  - Valida que `run_api_gis.bat` exista en la raíz del proyecto.

---

## 7) Resultado esperado

Al finalizar correctamente:

- API-GIS queda instalado con su `.venv`.
- El servicio queda registrado en Windows y visible en `services.msc`.
- La aplicación inicia automáticamente con el sistema.
