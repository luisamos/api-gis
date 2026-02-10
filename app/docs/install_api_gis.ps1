[CmdletBinding()]
param(
    [string]$InstallRoot = "C:\apps\api-gis",
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
        [string]$VenvPath
    )

    if (-not (Test-Path $VenvPath)) {
        Write-Host "Creando entorno virtual en $VenvPath"
        & py -3.12 -m venv $VenvPath
    }

    $pythonExe = Join-Path $VenvPath "Scripts\python.exe"

    & $pythonExe -m pip install --upgrade pip
    & $pythonExe -m pip install -r (Join-Path $Root "requirements.txt")
}

function Write-Launcher {
    param(
        [string]$Root,
        [string]$VenvPath,
        [string]$Host,
        [int]$Port
    )

    $launcherPath = Join-Path $Root "run_api_gis.bat"
    $pythonExe = Join-Path $VenvPath "Scripts\python.exe"

    $content = @"
@echo off
cd /d "$Root"
"$pythonExe" -m waitress --listen=$Host`:$Port app:create_app
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

$venvPath = Join-Path $InstallRoot ".venv"
Install-Dependencies -Root $InstallRoot -VenvPath $venvPath
$launcher = Write-Launcher -Root $InstallRoot -VenvPath $venvPath -Host $ListenHost -Port $ListenPort
Create-OrUpdate-Service -Name $ServiceName -LauncherPath $launcher

Write-Host "Instalación terminada."
Write-Host "Verifica el servicio en services.msc con el nombre: $ServiceName"