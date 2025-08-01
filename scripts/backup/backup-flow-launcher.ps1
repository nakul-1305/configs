# Color helper functions
function Write-Info   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [INFO]  $msg" -ForegroundColor Cyan }
function Write-Success{ param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [OK]    $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorC { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [ERROR] $msg" -ForegroundColor Red }

# === Paths ===
$source = "$env:APPDATA\FlowLauncher"
$dest   = ".\apps\flow-launcher"

# === Source Check ===
if (-not (Test-Path $source)) {
    Write-ErrorC "Source FlowLauncher config folder not found at $source"
    exit 1
} else {
    Write-Info "Found FlowLauncher config at $source"
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

# === Copy config except main Plugins folder ===
Write-Info "Copying everything except main Plugins folder"
try {
    Copy-Item -Path "$source\*" -Destination $dest -Recurse -Force -Exclude "Plugins"
    Write-Success "Copied core FlowLauncher config"
} catch {
    Write-Warn "Failed or partially failed to copy core config: $_"
}

# === Zip Plugins folder ===
$pluginsSrc = Join-Path $source "Plugins"
$pluginsZip = Join-Path $dest "Plugins.zip"

if (Test-Path $pluginsSrc) {
    Write-Info "Compressing Plugins folder (to avoid thousands of small files)"
    try {
        Compress-Archive -Path "$pluginsSrc\*" -DestinationPath $pluginsZip -Force
        Write-Success "Zipped Plugins folder to $pluginsZip"
    } catch {
        Write-Warn "Failed to compress Plugins folder: $_"
    }
} else {
    Write-Warn "Plugins folder not found at $pluginsSrc"
}

# === Cleanup sensitive / unnecessary items ===
Write-Info "Removing private and unnecessary files."
try {
    Remove-Item "$dest\Cache" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$dest\Logs" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$dest\Settings\*.bak" -Force -ErrorAction SilentlyContinue
    Remove-Item "$dest\Settings\History.json" -Force -ErrorAction SilentlyContinue
    Remove-Item "$dest\Settings\MultipleTopMostRecord.json" -Force -ErrorAction SilentlyContinue
    Remove-Item "$dest\Settings\UserSelectedRecord.json" -Force -ErrorAction SilentlyContinue

    # Remove .bak inside plugin settings directories
    Get-ChildItem "$dest\Settings\Plugins" -Directory -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item "$($_.FullName)\*.bak" -Force -ErrorAction SilentlyContinue
    }
    Write-Success "Cleanup complete."
} catch {
    Write-Warn "Errors during cleanup: $_"
}

Write-Success "FlowLauncher config backed up to $dest (Main Plugins folder zipped)."
Write-Info "Files removed: Cache/, Logs/, *.bak, History.json, MultipleTopMostRecord.json, UserSelectedRecord.json"
