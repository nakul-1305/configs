# === Color helper functions ===
function Write-Info { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [INFO]  $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [OK]    $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorC { param($msg) Write-Host "$(Get-Date -Format 'HH:mm:ss.fff') [ERROR] $msg" -ForegroundColor Red }

# === Paths ===
$windhawkProgData = "C:\ProgramData\Windhawk"
$modsSource = Join-Path $windhawkProgData "ModsSource"
$engineMods = Join-Path $windhawkProgData "Engine\Mods"

$destDir       = ".\apps\windhawk"
$destDirEngine = Join-Path $destDir "Engine"

# Registry keys
$regWindhawk = "HKLM\Software\Windhawk"

# === Installation check ===
$progDataExists = Test-Path $windhawkProgData
$regExists = Test-Path "Registry::$regWindhawk"

if (-not $progDataExists -and -not $regExists) {
    Write-ErrorC "Windhawk not installed: ProgramData folder and registry key are missing."
    exit 1
}
elseif (-not $progDataExists) {
    Write-ErrorC "Windhawk ProgramData folder missing: $windhawkProgData"
    exit 1
}
elseif (-not $regExists) {
    Write-ErrorC "Windhawk registry key missing: $regWindhawk"
    exit 1
}
else {
    Write-Info "Windhawk installation detected."
}

# === Prepare destination ===
try {
    if (Test-Path $destDir) {
        Write-Info "Removing old backup at $destDir"
        Remove-Item $destDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    New-Item -ItemType Directory -Path $destDirEngine -Force | Out-Null
    Write-Success "Prepared backup directory $destDir"
}
catch {
    Write-ErrorC "Failed to prepare backup directory: $_"
    exit 1
}

# === Backup ModsSource ===
if (Test-Path $modsSource) {
    try {
        Copy-Item -Path $modsSource -Destination (Join-Path $destDir "ModsSource") -Recurse -Force
        Write-Success "Backed up ModsSource"
    }
    catch { Write-Warn "Failed to backup ModsSource: $_" }
} else {
    Write-Warn "ModsSource not found at $modsSource"
}

# === Backup Engine\Mods ===
if (Test-Path $engineMods) {
    try {
        Copy-Item -Path $engineMods -Destination (Join-Path $destDirEngine "Mods") -Recurse -Force
        Write-Success "Backed up Engine\Mods"
    }
    catch { Write-Warn "Failed to backup Engine\Mods: $_" }
} else {
    Write-Warn "Engine\Mods not found at $engineMods"
}

# === Export registry key ===
$regWindhawkDest = Join-Path $destDir "Windhawk.reg"
if (Test-Path "Registry::$regWindhawk") {
    try {
        reg export $regWindhawk $regWindhawkDest /y | Out-Null
        Write-Success "Exported Windhawk registry to $regWindhawkDest"
    }
    catch { Write-Warn "Failed to export Windhawk registry: $_" }
} else {
    Write-Warn "Registry key not found: $regWindhawk"
}

Write-Success "Windhawk backup complete."
