# install_windows.ps1 — Installs drumkit.py dependencies on Windows
# Run from PowerShell: .\install_windows.ps1
# (you may need: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$VenvDir   = Join-Path $ScriptDir ".venv"

Write-Host "=== drumkit.py installer (Windows) ===" -ForegroundColor Cyan
Write-Host

# ── Check Python ──────────────────────────────────────────────────────────────
Write-Host "[1/3] Checking Python..." -ForegroundColor Yellow
try {
    $pyver = & python --version 2>&1
    Write-Host "      Found: $pyver"
} catch {
    Write-Error "Python not found. Install Python 3.10+ from https://python.org and add it to PATH."
    exit 1
}

# ── Virtual environment ───────────────────────────────────────────────────────
Write-Host
Write-Host "[2/3] Creating virtual environment at $VenvDir ..." -ForegroundColor Yellow
python -m venv $VenvDir

$pip  = Join-Path $VenvDir "Scripts\pip.exe"
$py   = Join-Path $VenvDir "Scripts\python.exe"

& $pip install --upgrade pip -q
& $pip install python-rtmidi sounddevice soundfile numpy

$ans = Read-Host "      Install scipy (optional, for sample-rate conversion)? [y/N]"
if ($ans -match "^[Yy]$") {
    & $pip install scipy
}

# ── Verify drumkit.bat exists ─────────────────────────────────────────────────
Write-Host
Write-Host "[3/3] Checking launcher..." -ForegroundColor Yellow
$bat = Join-Path $ScriptDir "drumkit.bat"
if (Test-Path $bat) {
    Write-Host "      drumkit.bat is ready."
} else {
    Write-Warning "drumkit.bat not found — it should be next to this script."
}

Write-Host
Write-Host "Done!  Run the kit with:" -ForegroundColor Green
Write-Host
Write-Host "  drumkit.bat                          # list MIDI controllers"
Write-Host "  drumkit.bat path\to\kit.xml          # run the kit"
Write-Host "  drumkit.bat path\to\kit.xml --remap  # re-do MIDI mapping"
Write-Host
Write-Host "Controls while playing:  [+] vol up   [-] vol down   [q] quit"
