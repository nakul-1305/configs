# Color helper functions
function Write-Info   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [INFO]  $msg" -ForegroundColor Cyan }
function Write-Success{ param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [OK]    $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorC { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [ERROR] $msg" -ForegroundColor Red }

# === Paths ===
$source   = Join-Path $env:USERPROFILE ".gitconfig"
$destDir  = ".\apps\git"
$destFile = Join-Path $destDir ".gitconfig"

# === Source Check ===
if (-not (Test-Path $source)) {
    Write-ErrorC "Source .gitconfig not found at $source"
    exit 1
} else {
    Write-Info "Found source .gitconfig at $source"
}

# === Prepare destination ===
try {
    if (Test-Path $destDir) {
        Write-Info "Ensuring existing destination file is removed if present"
        if (Test-Path $destFile) { Remove-Item $destFile -Force }
    }
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Write-Success "Prepared destination directory $destDir"
} catch {
    Write-ErrorC "Failed to prepare destination directory: $_"
    exit 1
}

# === Copy file ===
try {
    Copy-Item -Path $source -Destination $destFile -Force
    Write-Success ".gitconfig backed up to $destDir"
} catch {
    Write-ErrorC "Failed to copy .gitconfig: $_"
    exit 1
}
