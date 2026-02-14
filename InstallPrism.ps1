# === CONFIG ===
$PrismVersion = "10.0.2"
$PrismInstallerUrl = "https://github.com/PrismLauncher/PrismLauncher/releases/download/$PrismVersion/PrismLauncher-Windows-MSVC-Setup-$PrismVersion.exe"

Write-Host "Downloading Prism Launcher $PrismVersion installer..."

$tempInstaller = "$env:TEMP\PrismLauncherSetup.exe"

Invoke-WebRequest -Uri $PrismInstallerUrl -OutFile $tempInstaller -UseBasicParsing

Write-Host "Launching Prism Launcher installer..."
Start-Process $tempInstaller -Wait

$prismPath = "$env:APPDATA\PrismLauncher"

if (Test-Path $prismPath) {
    Write-Host "Prism Launcher successfully installed!"
} else {
    Write-Host "WARNING: Prism Launcher does not appear to be installed."
}

Start-Sleep -Seconds 2
