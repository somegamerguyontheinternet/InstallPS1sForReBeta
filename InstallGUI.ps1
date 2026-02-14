Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === CONFIG ===
$baseUrl = "https://raw.githubusercontent.com/somegamerguyontheinternet/InstallPS1sForReBeta/main"
$scriptDir = "$env:TEMP\ReBetaInstaller"
$prismScript = Join-Path $scriptDir "InstallPrism.ps1"
$rebetaScript = Join-Path $scriptDir "InstallReBeta.ps1"

if (!(Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir | Out-Null
}

function Download-Script($localPath, $remotePath) {
    Invoke-WebRequest -Uri $remotePath -OutFile $localPath -UseBasicParsing
}

# === GUI ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "ReBeta Installer"
$form.Size = New-Object System.Drawing.Size(420,260)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "Welcome to the ReBeta Installer"
$label.AutoSize = $true
$label.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$label.Location = New-Object System.Drawing.Point(80,20)
$form.Controls.Add($label)

# === BUTTON: Install Prism Launcher ===
$btnPrism = New-Object System.Windows.Forms.Button
$btnPrism.Text = "Install Prism Launcher"
$btnPrism.Size = New-Object System.Drawing.Size(300,40)
$btnPrism.Location = New-Object System.Drawing.Point(50,70)

$btnPrism.Add_Click({
    if (!(Test-Path $prismScript)) {
        Download-Script $prismScript "$baseUrl/InstallPrism.ps1"
    }
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$prismScript`""
})

$form.Controls.Add($btnPrism)

# === BUTTON: Install ReBeta ===
$btnReBeta = New-Object System.Windows.Forms.Button
$btnReBeta.Text = "Install ReBeta"
$btnReBeta.Size = New-Object System.Drawing.Size(300,40)
$btnReBeta.Location = New-Object System.Drawing.Point(50,130)

$btnReBeta.Add_Click({
    if (!(Test-Path $rebetaScript)) {
        Download-Script $rebetaScript "$baseUrl/InstallReBeta.ps1"
    }
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$rebetaScript`""
})

$form.Controls.Add($btnReBeta)

# === BUTTON: Exit ===
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Exit"
$btnExit.Size = New-Object System.Drawing.Size(300,40)
$btnExit.Location = New-Object System.Drawing.Point(50,190)

$btnExit.Add_Click({
    $form.Close()
})

$form.Controls.Add($btnExit)

[void]$form.ShowDialog()
