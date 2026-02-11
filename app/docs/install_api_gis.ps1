[CmdletBinding()]
param(
    [string]$InstallRoot = "C:\apps\python\api-gis",
    [string]$VenvPath = "C:\apps\python\.venv",
    [string]$ServiceName = "geoCatastro",
    [string]$PythonVersion = "3.13.2",
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

function Install-PythonRuntime {
    param([string]$Version)

    $installerName = "python-$Version-amd64.exe"
    $downloadUrl = "https://www.python.org/ftp/python/$Version/$installerName"
    $tmpInstaller = Join-Path $env:TEMP $installerName

    Write-Host "Descargando Python $Version desde $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tmpInstaller

    Write-Host "Instalando Python de forma silenciosa..."
    Start-Process -FilePath $tmpInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait

    Remove-Item $tmpInstaller -Force
    }

function Ensure-Python {
    param([string]$Version)

    $python = Get-Command py -ErrorAction SilentlyContinue
    $majorMinor = ($Version.Split('.')[0..1] -join '.')
    
    if (-not $python) {
        Install-PythonRuntime -Version $Version
        $python = Get-Command py -ErrorAction SilentlyContinue
        if (-not $python) {
            throw "No se pudo instalar Python automáticamente."
        }
    }

    if (-not (Test-PythonLauncherVersion -MajorMinor $majorMinor)) {
        Write-Host "Python launcher detectado, pero falta Python $majorMinor. Se instalará Python $Version."
        Install-PythonRuntime -Version $Version
        if (-not (Test-PythonLauncherVersion -MajorMinor $majorMinor)) {
            throw "Se instaló Python $Version, pero py no detecta la versión $majorMinor. Ejecuta 'py -0p' para revisar instalaciones y vuelve a intentar."
        }
    }

    Write-Host "Python $majorMinor disponible en py launcher."
}

function Test-PythonLauncherVersion {
    param([string]$MajorMinor)

    $tmpOut = [System.IO.Path]::GetTempFileName()
    $tmpErr = [System.IO.Path]::GetTempFileName()

    try {
        $process = Start-Process -FilePath "py" -ArgumentList "-$MajorMinor", "-c", "import sys" -Wait -PassThru -NoNewWindow -RedirectStandardOutput $tmpOut -RedirectStandardError $tmpErr
        return ($process.ExitCode -eq 0)
    }
    finally {
        Remove-Item -Path $tmpOut, $tmpErr -Force -ErrorAction SilentlyContinue
    }
}

function Ensure-Project {
    param([string]$Root)

    if (-not (Test-Path $Root)) {
        $currentPath = (Get-Location).Path
        throw "No existe la carpeta del proyecto: $Root. Ruta actual: $currentPath. Ajusta -InstallRoot para que coincida con la ubicación real del repositorio."
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

    $pythonExe = Join-Path $VirtualEnvPath "Scripts\python.exe"
    if (-not (Test-Path $pythonExe)) {
        $venvParent = Split-Path -Path $VirtualEnvPath -Parent
        if (-not (Test-Path $venvParent)) {
            New-Item -ItemType Directory -Path $venvParent -Force | Out-Null
        }

        if (Test-Path $VirtualEnvPath) {
            Write-Host "Entorno virtual incompleto detectado en $VirtualEnvPath. Se recreará."
            Remove-Item -Path $VirtualEnvPath -Recurse -Force
        }

        Write-Host "Creando entorno virtual en $VirtualEnvPath"
        $majorMinor = ($PythonVersion.Split('.')[0..1] -join '.')
        & py -$majorMinor -m venv $VirtualEnvPath

        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $pythonExe)) {
            throw "No se pudo crear el entorno virtual con Python $majorMinor en '$VirtualEnvPath'. Verifica que 'py -0p' muestre una instalación válida para $majorMinor."
        }
    }

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