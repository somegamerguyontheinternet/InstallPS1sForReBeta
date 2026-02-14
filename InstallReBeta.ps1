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

Write-Host "Extracting ReBeta..."
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Find the FIRST folder inside the extracted ZIP
$rootFolder = Get-ChildItem $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if ($null -eq $rootFolder) {
    Write-Host "ERROR: Could not find extracted instance folder."
    exit
}

# If the ZIP contains a nested folder, use that instead
$innerFolder = Get-ChildItem $rootFolder.FullName | Where-Object { $_.PSIsContainer } | Select-Object -First 1
if ($innerFolder -ne $null) {
    $sourceFolder = $innerFolder.FullName
} else {
    $sourceFolder = $rootFolder.FullName
}

Write-Host "Source folder detected:"
Write-Host "  $sourceFolder"

Write-Host "Installing into:"
Write-Host "  $rebetaInstancePath"

# Windows will auto-create the folder if needed
Copy-Item -Path (Join-Path $sourceFolder "*") -Destination $rebetaInstancePath -Recurse -Force

Write-Host "ReBeta installed successfully!"
Write-Host "You may now close this window."
Start-Sleep -Seconds 3
