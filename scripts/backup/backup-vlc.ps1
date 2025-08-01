# Color helper functions
function Write-Info   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [INFO]  $msg" -ForegroundColor Cyan }
function Write-Success{ param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [OK]    $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorC { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [ERROR] $msg" -ForegroundColor Red }

# === Paths ===
$source = "$env:APPDATA\vlc\vlcrc"
$dest   = ".\apps\vlc\vlcrc"

# === Source Check ===
if (-not (Test-Path $source)) {
    Write-ErrorC "Source vlcrc not found at $source"
    exit 1
} else {
    Write-Info "Found source vlcrc at $source"
}

# === Ensure destination directory exists ===
$destDir = Split-Path $dest
if (-not (Test-Path $destDir)) {
    try {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Write-Success "Created destination directory $destDir"
    } catch {
        Write-ErrorC "Failed to create destination directory: $_"
        exit 1
    }
} else {
    Write-Info "Destination directory already exists: $destDir"
}

# === Clean and backup vlcrc ===
try {
    Get-Content $source |
      Where-Object { ($_ -notmatch '^\s*#') -and ($_ -match '\S') } |
      Set-Content $dest -Encoding utf8
    Write-Success "Cleaned vlcrc file and saved backup at $dest"
} catch {
    Write-ErrorC "Failed to process vlcrc: $_"
    exit 1
}
