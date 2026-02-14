Write-Host "Checking Prism Launcher installation..."

$prismInstances = "$env:APPDATA\PrismLauncher\instances"
$rebetaInstancePath = Join-Path $prismInstances "ReBeta"

if (!(Test-Path $prismInstances)) {
    Write-Host "ERROR: Prism Launcher is not installed."
    Write-Host "Please install Prism Launcher first."
    exit
}

Write-Host "Downloading ReBeta instance..."

$zipUrl = "https://codeload.github.com/somegamerguyontheinternet/ReBeta-Instance/zip/refs/heads/main"
$tempZip = "$env:TEMP\ReBeta.zip"
$tempExtract = "$env:TEMP\ReBetaExtract"

# Clean old temp
Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing

Write-Host "Extracting ReBeta using tar.exe (stable extractor)..."

# Create extract folder
New-Item -ItemType Directory -Path $tempExtract | Out-Null

# Use tar.exe instead of Expand-Archive
tar -xf $tempZip -C $tempExtract

# === AUTO-DETECT INSTANCE ROOT ===
# Find the folder that contains instance.cfg (the true instance root)
$instanceCfg = Get-ChildItem -Recurse -Filter "instance.cfg" -Path $tempExtract | Select-Object -First 1

if ($null -eq $instanceCfg) {
    Write-Host "ERROR: Could not locate instance.cfg inside the downloaded ZIP."
    Write-Host "The ReBeta instance may be packaged incorrectly."
    exit
}

$sourceFolder = Split-Path $instanceCfg.FullName -Parent

Write-Host "Detected instance folder:"
Write-Host "  $sourceFolder"

# === PREPARE ReBeta INSTANCE FOLDER ===
if (!(Test-Path $rebetaInstancePath)) {
    New-Item -ItemType Directory -Path $rebetaInstancePath | Out-Null
} else {
    # Clean existing contents
    Remove-Item (Join-Path $rebetaInstancePath "*") -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Installing ReBeta instance into:"
Write-Host "  $rebetaInstancePath"

# === COPY INSTANCE FILES ===
Copy-Item -Path (Join-Path $sourceFolder "*") -Destination $rebetaInstancePath -Recurse -Force

Write-Host "ReBeta installed successfully!"
Write-Host "You may now close this window."
Start-Sleep -Seconds 3
