# Color helper functions
function Write-Info   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [INFO]  $msg" -ForegroundColor Cyan }
function Write-Success{ param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [OK]    $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorC { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [ERROR] $msg" -ForegroundColor Red }

# === Paths ===
$destBase         = ".\apps\vscode"
$usersettingsDest = Join-Path $destBase "usersettings"
$extensionsDest   = Join-Path $destBase "extensions"

$settingsJsonSrc  = Join-Path $env:APPDATA "Code\User\settings.json"

$extensionsSrc    = Join-Path $env:USERPROFILE ".vscode\extensions"
$vscodeDir        = Join-Path $env:USERPROFILE ".vscode"
$extensionsJson   = Join-Path $vscodeDir "extensions\extensions.json"
$extensionsJsonBak= Join-Path $vscodeDir "extensions.json.bak"

# temp zip placed in user vscode dir first
$tempZip          = Join-Path $vscodeDir "extensions.zip"

# final zip path
$finalZipDest     = Join-Path $extensionsDest "extensions.zip"

# Clean previous backup base
if (Test-Path $destBase) {
    Write-Info "Removing existing destination base at $destBase"
    Remove-Item $destBase -Recurse -Force
}
New-Item -ItemType Directory -Path $usersettingsDest -Force | Out-Null
New-Item -ItemType Directory -Path $extensionsDest -Force | Out-Null
Write-Success "Prepared backup directories."

# === Backup settings.json ===
if (Test-Path $settingsJsonSrc) {
    Copy-Item -Path $settingsJsonSrc -Destination (Join-Path $usersettingsDest "settings.json") -Force
    Write-Success "Backed up settings.json to $usersettingsDest"
} else {
    Write-Warn "settings.json not found at $settingsJsonSrc"
}

# === Handle extensions.json ===
if (Test-Path $extensionsJson) {
    Move-Item -Path $extensionsJson -Destination $extensionsJsonBak -Force
    Write-Success "Moved extensions.json to extensions.json.bak"
} else {
    Write-Warn "No extensions.json found at $extensionsJson"
}

# === Zip extensions folder ===
if (-not (Test-Path $extensionsSrc)) {
    Write-ErrorC "Extensions source folder not found at $extensionsSrc"
    exit 1
}

if (Test-Path $tempZip) {
    Write-Info "Removing existing temporary zip at $tempZip"
    Remove-Item $tempZip -Force
}
try {
    Compress-Archive -Path (Join-Path $extensionsSrc "*") -DestinationPath $tempZip -Force
    Write-Success "Created zip of extensions at $tempZip"
} catch {
    Write-ErrorC "Failed to create archive: $_"
    exit 1
}

# Move zip into backup destination
try {
    Move-Item -Path $tempZip -Destination $finalZipDest -Force
    Write-Success "Moved zip to $finalZipDest"
} catch {
    Write-ErrorC "Failed to move zip to destination: $_"
    exit 1
}

# === Restore extensions.json and also store a copy in backup ===
if (Test-Path $extensionsJsonBak) {
    Copy-Item -Path $extensionsJsonBak -Destination $extensionsJson -Force
    Write-Success "Restored extensions.json from .bak"
} else {
    Write-Warn "No extensions.json.bak to restore from"
}

Write-Host ""  # spacing
Write-Success "VSCode extension backup complete."
