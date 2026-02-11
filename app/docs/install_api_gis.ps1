[CmdletBinding()]
param(
    [string]$InstallRoot = "C:\apps\python\api-gis",
    [string]$VenvPath = "C:\apps\python\.venv",
    [string]$ServiceName = "geoCatastro",
    [string]$PythonVersion = "3.12.7",
    [string]$ListenHost = "0.0.0.0",
    [int]$ListenPort = 5000
)

$ErrorActionPreference = "Stop"

function Require-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "Este script debe ejecutarse como Administrador."
    }
}

function Ensure-Python {
    param([string]$Version)

    $python = Get-Command py -ErrorAction SilentlyContinue
    if ($python) {
        Write-Host "Python launcher detectado. Se omite instalación de Python."
        return
    }

    $majorMinor = ($Version.Split('.')[0..1] -join '.')
    $installerName = "python-$Version-amd64.exe"
    $downloadUrl = "https://www.python.org/ftp/python/$Version/$installerName"
    $tmpInstaller = Join-Path $env:TEMP $installerName

    Write-Host "Descargando Python $Version desde $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tmpInstaller

    Write-Host "Instalando Python de forma silenciosa..."
    Start-Process -FilePath $tmpInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait

    Remove-Item $tmpInstaller -Force

    $python = Get-Command py -ErrorAction SilentlyContinue
    if (-not $python) {
        throw "No se pudo instalar Python automáticamente."
    }

    Write-Host "Python instalado correctamente."
}

function Ensure-Project {
    param([string]$Root)

    if (-not (Test-Path $Root)) {
        throw "No existe la carpeta del proyecto: $Root"
    }

    $requirements = Join-Path $Root "requirements.txt"
    if (-not (Test-Path $requirements)) {
        throw "No se encontró requirements.txt en $Root"
    }
}

function Install-Dependencies {
    param(
        [string]$Root,
        [string]$VirtualEnvPath,
        [string]$PythonVersion
    )

    if (-not (Test-Path $VirtualEnvPath)) {
        $venvParent = Split-Path -Path $VirtualEnvPath -Parent
        if (-not (Test-Path $venvParent)) {
            New-Item -ItemType Directory -Path $venvParent -Force | Out-Null
        }

        Write-Host "Creando entorno virtual en $VirtualEnvPath"
        $majorMinor = ($PythonVersion.Split('.')[0..1] -join '.')
        & py -$majorMinor -m venv $VirtualEnvPath
    }

    $pythonExe = Join-Path $VirtualEnvPath "Scripts\python.exe"
    $requirementsPath = Join-Path $Root "requirements.txt"
    $tempRequirements = Join-Path $env:TEMP "requirements_api_gis_nogdal.txt"
    $wheelDir = Join-Path $Root "app\lib"
    $pyTag = & $pythonExe -c "import sys; print(f'cp{sys.version_info.major}{sys.version_info.minor}')"

    # Evitar instalar GDAL desde requirements para no disparar compilación en Windows.
    Get-Content $requirementsPath |
        Where-Object { $_ -notmatch '^\s*gdal\s*==.*$' } |
        Set-Content -Path $tempRequirements -Encoding ASCII

    & $pythonExe -m pip install --upgrade pip
    & $pythonExe -m pip install --upgrade "setuptools<70" wheel
    & $pythonExe -m pip install -r $tempRequirements

    if (Test-Path $wheelDir) {
        $gdalWheel = Get-ChildItem -Path $wheelDir -Filter "gdal-*-$pyTag-*-win_amd64.whl" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($gdalWheel) {
            Write-Host "Instalando GDAL desde wheel local: $($gdalWheel.Name)"
            & $pythonExe -m pip install --no-index --find-links $wheelDir gdal
            Remove-Item $tempRequirements -Force -ErrorAction SilentlyContinue
            return
        }
    }

    Remove-Item $tempRequirements -Force -ErrorAction SilentlyContinue
    throw "No se encontró wheel local de GDAL para $pyTag en '$wheelDir'. Agrega un archivo gdal-*-$pyTag-*-win_amd64.whl o ajusta PythonVersion para usar una versión con wheel disponible."
}

function Write-Launcher {
    param(
        [string]$Root,
        [string]$VirtualEnvPath,
        [string]$ListenAddress,
        [int]$Port
    )

    $launcherPath = Join-Path $Root "run_api_gis.bat"
    $pythonExe = Join-Path $VirtualEnvPath "Scripts\python.exe"

    $content = @"
@echo off
cd /d "$Root"
"$pythonExe" -m waitress --listen=$ListenAddress`:$Port app:create_app
"@

    Set-Content -Path $launcherPath -Value $content -Encoding ASCII
    return $launcherPath
}

function Create-OrUpdate-Service {
    param(
        [string]$Name,
        [string]$LauncherPath
    )

    $service = Get-Service -Name $Name -ErrorAction SilentlyContinue

    if ($service) {
        Write-Host "El servicio $Name ya existe. Se actualizará configuración."
        sc.exe stop $Name | Out-Null
        sc.exe config $Name start= auto obj= LocalSystem | Out-Null
        sc.exe config $Name binPath= "cmd.exe /c \"$LauncherPath\"" | Out-Null
    }
    else {
        Write-Host "Creando servicio de Windows $Name"
        sc.exe create $Name binPath= "cmd.exe /c \"$LauncherPath\"" start= auto obj= LocalSystem DisplayName= "API-GIS Service" | Out-Null
    }

    sc.exe description $Name "Servicio API-GIS (Flask/Waitress)" | Out-Null
    sc.exe start $Name | Out-Null
}

Require-Admin
Ensure-Project -Root $InstallRoot
Ensure-Python -Version $PythonVersion

Install-Dependencies -Root $InstallRoot -VirtualEnvPath $VenvPath -PythonVersion $PythonVersion
$launcher = Write-Launcher -Root $InstallRoot -VirtualEnvPath $VenvPath -ListenAddress $ListenHost -Port $ListenPort
Create-OrUpdate-Service -Name $ServiceName -LauncherPath $launcher

Write-Host "Instalación terminada."
Write-Host "Verifica el servicio en services.msc con el nombre: $ServiceName"