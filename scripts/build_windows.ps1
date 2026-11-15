# Local Windows Build Automation for Dark Fort: Lost Treasure
param(
    [string]$GodotPath = "C:\Users\nandan m\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe",
    [string]$OutputDir = "build\windows"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " DARK FORT: LOST TREASURE - BUILD SCRIPT " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Verify Godot executable
if (-not (Test-Path $GodotPath)) {
    Write-Error "Godot binary not found at $GodotPath"
    exit 1
}

# 2. Run automated test suite
Write-Host "`n[1/3] Running automated gameplay test suite..." -ForegroundColor Yellow
& $GodotPath --headless --path . "res://tests/test_gameplay.tscn"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Automated test suite failed! Halting build."
    exit $LASTEXITCODE
}
Write-Host "Automated tests passed!" -ForegroundColor Green

# 3. Create output directory
Write-Host "`n[2/3] Preparing output directory: $OutputDir..." -ForegroundColor Yellow
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# 4. Export PCK or project
Write-Host "`n[3/3] Exporting Windows PCK package..." -ForegroundColor Yellow
$pckOutput = Join-Path $OutputDir "DarkFort.pck"
& $GodotPath --headless --path . --export-pack "Windows Desktop" $pckOutput

if ($LASTEXITCODE -eq 0 -and (Test-Path $pckOutput)) {
    Write-Host "`nExport succeeded! Package created at: $pckOutput" -ForegroundColor Green
} else {
    Write-Host "`nPCK export completed with exit code: $LASTEXITCODE" -ForegroundColor Yellow
}

Write-Host "Build process complete." -ForegroundColor Cyan
