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

Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing

Write-Host "Extracting ReBeta..."
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Find the extracted root folder (e.g. ReBeta-Instance-main)
$rootFolder = Get-ChildItem $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if ($null -eq $rootFolder) {
    Write-Host "ERROR: Could not find extracted instance folder."
    exit
}

# If your repo has ReBeta-Instance-main\ReBeta-Instance-main, handle that:
$innerFolder = Get-ChildItem $rootFolder.FullName | Where-Object { $_.PSIsContainer } | Select-Object -First 1
if ($innerFolder -ne $null) {
    $sourceFolder = $innerFolder.FullName
} else {
    $sourceFolder = $rootFolder.FullName
}

Write-Host "Preparing ReBeta instance folder..."

if (!(Test-Path $rebetaInstancePath)) {
    New-Item -ItemType Directory -Path $rebetaInstancePath | Out-Null
} else {
    # Optional: clean existing contents
    Remove-Item (Join-Path $rebetaInstancePath "*") -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Installing ReBeta instance into:"
Write-Host "  $rebetaInstancePath"

Copy-Item -Path (Join-Path $sourceFolder "*") -Destination $rebetaInstancePath -Recurse -Force

Write-Host "ReBeta installed successfully!"
Write-Host "You may now close this window."
Start-Sleep -Seconds 3
