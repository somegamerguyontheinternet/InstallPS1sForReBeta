Write-Host "Checking Prism Launcher installation..."

$prismInstances = "$env:APPDATA\PrismLauncher\instances"

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

$instanceFolder = Get-ChildItem $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if ($null -eq $instanceFolder) {
    Write-Host "ERROR: Could not find extracted instance folder."
    exit
}

Write-Host "Installing ReBeta instance..."

Copy-Item -Path "$($instanceFolder.FullName)\*" -Destination $prismInstances -Recurse -Force

Write-Host "ReBeta installed successfully!"
Write-Host "You may now close this window."
Start-Sleep -Seconds 3
