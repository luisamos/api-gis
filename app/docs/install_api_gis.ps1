[CmdletBinding()]
param(
    [string]$InstallRoot = "C:\apps\python\api-gis",
    [string]$VenvPath = "C:\apps\python\.venv",
    [string]$ServiceName = "",
    [string]$PythonVersion = "3.13.2",
    [string]$ListenHost = "127.0.0.1",
    [int]$ListenPort = 5000
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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
    & $tmpInstaller /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    if ($LASTEXITCODE -ne 0) {
        throw "La instalación silenciosa de Python finalizó con código $LASTEXITCODE."
    }

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

    $pythonExe = Get-PythonExecutable -MajorMinor $majorMinor
    if (-not $pythonExe) {
        throw "Python $majorMinor está instalado, pero no se pudo resolver su ejecutable."
    }

    Write-Host "Python $majorMinor disponible: $pythonExe"
    return $pythonExe
}

function Get-PythonExecutable {
    param([string]$MajorMinor)

    $resolved = (& py "-$MajorMinor" -c "import sys; print(sys.executable)" 2>$null)
    if ($LASTEXITCODE -eq 0 -and $resolved) {
        $path = $resolved | Select-Object -First 1
        if (Test-Path $path) {
            return $path
        }
    }

    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCmd) {
        $version = (& python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>$null)
        if ($LASTEXITCODE -eq 0 -and $version -eq $MajorMinor) {
            return $pythonCmd.Source
        }
    }

    return $null
}

function Test-PythonLauncherVersion {
    param([string]$MajorMinor)

    # Evitar Start-Process con el launcher de Python porque puede estar bloqueado
    # por directivas corporativas (error "Acceso denegado") en algunos equipos.
    & py "-$MajorMinor" -c "import sys" 1>$null 2>$null
    return ($LASTEXITCODE -eq 0)
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

function Ensure-Nssm {
    param(
        [string]$Root
    )

    $toolsDir = Join-Path $Root "tools"
    $nssmPath = Join-Path $toolsDir "nssm.exe"
    if (Test-Path $nssmPath) {
        return $nssmPath
    }

    New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null

    $localZipPath = Join-Path $Root "app\lib\nssm-2.24.zip"
    $zipPath = Join-Path $env:TEMP "nssm-2.24.zip"
    $extractDir = Join-Path $env:TEMP "nssm-2.24"
    if (-not (Test-Path $localZipPath)) {
        throw "No se encontró NSSM local en '$localZipPath'. Copia 'nssm-2.24.zip' en app/lib antes de ejecutar la instalación."
    }

    Write-Host "Usando NSSM local desde $localZipPath"
    Copy-Item -Path $localZipPath -Destination $zipPath -Force

    if (Test-Path $extractDir) {
        Remove-Item -Path $extractDir -Recurse -Force
    }

    Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

    $archFolder = if ([Environment]::Is64BitOperatingSystem) { "win64" } else { "win32" }
    $sourceExe = Get-ChildItem -Path $extractDir -Filter "nssm.exe" -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match "\\$archFolder\\nssm\.exe$" } |
        Select-Object -ExpandProperty FullName -First 1

    if (-not (Test-Path $sourceExe)) {
        throw "No se encontró nssm.exe en el paquete descargado."
    }

    Copy-Item -Path $sourceExe -Destination $nssmPath -Force

    Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $extractDir -Recurse -Force -ErrorAction SilentlyContinue

    return $nssmPath
}

function Create-OrUpdate-Service {
    param(
        [string]$Name,
        [string]$LauncherPath,
        [string]$Root,
        [string]$VirtualEnvPath,
        [string]$ListenAddress,
        [int]$Port
    )

    if (-not (Test-Path $LauncherPath)) {
        throw "No existe el launcher para el servicio: $LauncherPath"
    }

    $service = Get-Service -Name $Name -ErrorAction SilentlyContinue
    $pythonExe = Join-Path $VirtualEnvPath "Scripts\python.exe"
    if (-not (Test-Path $pythonExe)) {
        throw "No se encontró python.exe del entorno virtual en: $pythonExe"
    }

    $nssmExe = Ensure-Nssm -Root $Root
    $arguments = "-m waitress --listen=$ListenAddress`:$Port app:create_app"
    $stdoutLog = Join-Path $Root "logs\api-gis-service.log"
    $stderrLog = Join-Path $Root "logs\api-gis-service-error.log"

    New-Item -ItemType Directory -Path (Split-Path $stdoutLog -Parent) -Force | Out-Null

    if ($service) {
        Write-Host "El servicio $Name ya existe. Se actualizará configuración."
        $null = & $nssmExe stop $Name
        $null = & $nssmExe set $Name Application $pythonExe
        if ($LASTEXITCODE -ne 0) {
            throw "No se pudo actualizar la aplicación del servicio '$Name'."
        }

        $null = & $nssmExe set $Name AppParameters $arguments
        if ($LASTEXITCODE -ne 0) {
            throw "No se pudieron actualizar los argumentos del servicio '$Name'."
        }

        $null = & $nssmExe set $Name AppDirectory $Root
        if ($LASTEXITCODE -ne 0) {
            throw "No se pudo actualizar el directorio de trabajo del servicio '$Name'."
        }

        $null = & $nssmExe set $Name Start SERVICE_AUTO_START
        if ($LASTEXITCODE -ne 0) {
            throw "No se pudo configurar inicio automático para el servicio '$Name'."
        }
    }
    else {
        Write-Host "Creando servicio de Windows $Name"
        $null = & $nssmExe install $Name $pythonExe $arguments
        if ($LASTEXITCODE -ne 0) {
            throw "No se pudo crear el servicio '$Name'."
        }

        $null = & $nssmExe set $Name DisplayName "API-GIS Service"
        $null = & $nssmExe set $Name Start SERVICE_AUTO_START
    }

    $null = & $nssmExe set $Name AppDirectory $Root
    $null = & $nssmExe set $Name AppStdout $stdoutLog
    $null = & $nssmExe set $Name AppStderr $stderrLog
    $null = & $nssmExe set $Name AppRotateFiles 1
    $null = & $nssmExe set $Name AppRotateOnline 1

    $null = & sc.exe description $Name "Servicio API-GIS (geoCatastro) para el proceso de cargado del catastro predial municipal."
    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo actualizar la descripción del servicio '$Name'."
    }

    $null = & $nssmExe start $Name
    if ($LASTEXITCODE -ne 0) {
        throw "El servicio '$Name' se creó/configuró, pero no pudo iniciar. Revisa Event Viewer, run_api_gis.bat y los logs en $Root\logs."
    }

    $queryOutput = & sc.exe query $Name
    if ($LASTEXITCODE -ne 0) {
        throw "Se intentó crear/configurar el servicio '$Name', pero no aparece al consultar con sc.exe query."
    }

    Write-Host ($queryOutput | Out-String)
}

Require-Admin
Ensure-Project -Root $InstallRoot
Ensure-Python -Version $PythonVersion

Install-Dependencies -Root $InstallRoot -VirtualEnvPath $VenvPath -PythonVersion $PythonVersion
$launcher = Write-Launcher -Root $InstallRoot -VirtualEnvPath $VenvPath -ListenAddress $ListenHost -Port $ListenPort
Create-OrUpdate-Service -Name $ServiceName -LauncherPath $launcher -Root $InstallRoot -VirtualEnvPath $VenvPath -ListenAddress $ListenHost -Port $ListenPort

Write-Host ("Instalaci{0}n terminada." -f [char]243)
Write-Host "Verifica el servicio en services.msc con el nombre: $ServiceName"