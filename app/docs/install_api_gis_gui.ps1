[CmdletBinding()]
param(
    [string]$InstallerScriptPath = "app/docs/install_api_gis.ps1"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function New-LabeledTextBox {
    param(
        [System.Windows.Forms.Form]$Form,
        [string]$Label,
        [string]$DefaultValue,
        [int]$Top
    )

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Label
    $label.Left = 20
    $label.Top = $Top
    $label.Width = 220
    $Form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Left = 250
    $textBox.Top = $Top - 3
    $textBox.Width = 420
    $textBox.Text = $DefaultValue
    $Form.Controls.Add($textBox)

    return $textBox
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Instalador API-GIS (Windows)"
$form.Size = New-Object System.Drawing.Size(730, 510)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

$txtInstallRoot = New-LabeledTextBox -Form $form -Label "InstallRoot" -DefaultValue "C:\apps\python\api-gis" -Top 30
$txtVenvPath = New-LabeledTextBox -Form $form -Label "VenvPath" -DefaultValue "C:\apps\python\.venv" -Top 70
$txtServiceName = New-LabeledTextBox -Form $form -Label "ServiceName" -DefaultValue "geoCatastro" -Top 110
$txtPythonVersion = New-LabeledTextBox -Form $form -Label "PythonVersion" -DefaultValue "3.13.2" -Top 150
$txtListenHost = New-LabeledTextBox -Form $form -Label "ListenHost" -DefaultValue "127.0.0.1" -Top 190
$txtListenPort = New-LabeledTextBox -Form $form -Label "ListenPort" -DefaultValue "5000" -Top 230

$info = New-Object System.Windows.Forms.Label
$info.Left = 20
$info.Top = 270
$info.Width = 650
$info.Height = 50
$info.Text = "Este asistente ejecuta install_api_gis.ps1 como Administrador. El script principal instala GDAL Core y registra PROJ_LIB automáticamente."
$form.Controls.Add($info)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Multiline = $true
$txtOutput.ScrollBars = "Vertical"
$txtOutput.ReadOnly = $true
$txtOutput.Left = 20
$txtOutput.Top = 330
$txtOutput.Width = 650
$txtOutput.Height = 100
$form.Controls.Add($txtOutput)

$btnInstall = New-Object System.Windows.Forms.Button
$btnInstall.Text = "Instalar"
$btnInstall.Left = 480
$btnInstall.Top = 440
$btnInstall.Width = 90
$form.Controls.Add($btnInstall)

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Cerrar"
$btnClose.Left = 580
$btnClose.Top = 440
$btnClose.Width = 90
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

$btnInstall.Add_Click({
    try {
        $scriptFullPath = Resolve-Path -Path $InstallerScriptPath -ErrorAction Stop

        $parsedPort = 0
        if (-not [int]::TryParse($txtListenPort.Text, [ref]$parsedPort)) {
            throw "ListenPort debe ser numérico."
        }

        $arguments = @(
            "-ExecutionPolicy", "Bypass",
            "-File", ('"{0}"' -f $scriptFullPath),
            "-InstallRoot", ('"{0}"' -f $txtInstallRoot.Text),
            "-VenvPath", ('"{0}"' -f $txtVenvPath.Text),
            "-ServiceName", ('"{0}"' -f $txtServiceName.Text),
            "-PythonVersion", ('"{0}"' -f $txtPythonVersion.Text),
            "-ListenHost", ('"{0}"' -f $txtListenHost.Text),
            "-ListenPort", $txtListenPort.Text
        ) -join ' '

        $txtOutput.AppendText("Iniciando instalador...`r`n")
        $process = Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs -PassThru -Wait

        if ($process.ExitCode -eq 0) {
            $txtOutput.AppendText("Instalación finalizada correctamente.`r`n")
            [System.Windows.Forms.MessageBox]::Show("Instalación completada.", "API-GIS", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        }
        else {
            $txtOutput.AppendText("El instalador terminó con código: $($process.ExitCode)`r`n")
            [System.Windows.Forms.MessageBox]::Show("Falló la instalación. Código: $($process.ExitCode)", "API-GIS", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        }
    }
    catch {
        $txtOutput.AppendText("Error: $($_.Exception.Message)`r`n")
        [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "API-GIS", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    }
})

[void]$form.ShowDialog()