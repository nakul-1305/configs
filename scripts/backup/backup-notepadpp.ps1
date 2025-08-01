# Color helper functions
function Write-Info   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [INFO]  $msg" -ForegroundColor Cyan }
function Write-Success{ param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [OK]    $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorC { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [ERROR] $msg" -ForegroundColor Red }

# === Paths ===
$source = "$env:APPDATA\Notepad++"
$dest   = ".\apps\notepadpp"

# === Source Check ===
if (-not (Test-Path $source)) {
    Write-ErrorC "Source Notepad++ config folder not found at $source"
    exit 1
} else {
    Write-Info "Found Notepad++ config at $source"
}

# === Prepare destination ===
try {
    if (Test-Path $dest) {
        Write-Info "Removing existing destination at $dest"
        Remove-Item $dest -Recurse -Force
    }
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    Write-Success "Prepared destination directory $dest"
} catch {
    Write-ErrorC "Failed to prepare destination: $_"
    exit 1
}

# === Copy configuration ===
try {
    Copy-Item -Path (Join-Path $source '*') -Destination $dest -Recurse -Force
    Write-Success "Copied Notepad++ config to $dest"
} catch {
    Write-ErrorC "Failed to copy config: $_"
    exit 1
}

# === Clean unwanted items ===
Write-Info "Removing private and unnecessary files."
try {
    Remove-Item -Path (Join-Path $dest 'backup') -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $dest '*.log') -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $dest '*.bak') -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $dest 'session.xml') -Force -ErrorAction SilentlyContinue
    Write-Success "Cleaned up unwanted items from backup."
} catch {
    Write-Warn "Some cleanup steps failed or partially succeeded: $_"
}

Write-Success "Notepad++ config backed up to $dest."
