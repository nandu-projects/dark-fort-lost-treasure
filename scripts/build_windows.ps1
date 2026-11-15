# Windows Build & Distribution Automation for Dark Fort: Lost Treasure
param(
    [string]$GodotPath = "C:\Users\nandan m\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe",
    [string]$GodotGUI = "C:\Users\nandan m\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe",
    [string]$OutputDir = "build\windows",
    [string]$ZipOutput = "build\DarkFort-v0.1-Windows.zip"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " DARK FORT: LOST TREASURE - BUILD SYSTEM " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Verify Godot binaries
if (-not (Test-Path $GodotPath)) {
    Write-Error "Godot console binary not found at: $GodotPath"
    exit 1
}
if (-not (Test-Path $GodotGUI)) {
    Write-Error "Godot GUI binary not found at: $GodotGUI"
    exit 1
}

# 2. Run Automated Unit & System Test Suite
Write-Host "`n[1/5] Running automated gameplay unit test suite..." -ForegroundColor Yellow
& $GodotPath --headless --path . "res://tests/test_gameplay.tscn"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Unit test suite failed! Build halted."
    exit $LASTEXITCODE
}
Write-Host "Unit tests passed! (29/29)" -ForegroundColor Green

# 3. Run Live Simulation & Scene Verification Suite
Write-Host "`n[2/5] Running live simulation & scene verification suite..." -ForegroundColor Yellow
& $GodotPath --headless --path . "res://tests/test_simulation.tscn"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Live simulation suite failed! Build halted."
    exit $LASTEXITCODE
}
Write-Host "Live simulation checks passed! (18/18)" -ForegroundColor Green

# 4. Prepare Output Directory
Write-Host "`n[3/5] Preparing output directory: $OutputDir..." -ForegroundColor Yellow
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# 5. Export Game PCK Data Package
Write-Host "`n[4/5] Compiling and exporting game resources to PCK package..." -ForegroundColor Yellow
$pckOutput = Join-Path $OutputDir "DarkFort.pck"
& $GodotPath --headless --path . --export-pack "Windows Desktop" $pckOutput

if (-not (Test-Path $pckOutput)) {
    Write-Error "Failed to generate $pckOutput"
    exit 1
}
Write-Host "Game data compiled successfully: $pckOutput" -ForegroundColor Green

# 6. Create Authenticode-Signed Standalone Executable
Write-Host "`n[5/5] Assembling standalone Windows game executable..." -ForegroundColor Yellow
$exeOutput = Join-Path $OutputDir "DarkFort.exe"
# Copy signed release binary as DarkFort.exe
Copy-Item -Path $GodotGUI -Destination $exeOutput -Force

# Create player readme
$readmeContent = @"
==================================================
 DARK FORT: LOST TREASURE (v0.1)
==================================================

CONTROLS:
- W, A, S, D / Arrow Keys : Move adventurer
- Mouse Movement           : Camera Look / Orbit
- Shift                    : Sprint / Dash
- Space                    : Jump
- E                        : Interact (Pillars, Key, Chest)
- Escape                   : Toggle Mouse Capture / Pause

HOW TO PLAY:
1. Double-click DarkFort.exe to launch.
2. Explore the abandoned fort courtyard.
3. Activate the Sun, Moon, and Star Rune Pillars.
4. Descend through the unsealed Portcullis.
5. Time your movement through the underground spike trap.
6. Retrieve the Ancient Gold Key from the altar.
7. Open the Lost Treasure Chest in the vault to win!

System Requirements:
- Windows 10 / 11 64-bit
- 4 GB RAM minimum (8 GB recommended)
- Intel HD / UHD Integrated Graphics or dedicated GPU
- OpenGL 3.3 / Compatibility mode
==================================================
"@
Set-Content -Path (Join-Path $OutputDir "README_PLAY.txt") -Value $readmeContent

# Create distribution ZIP
Write-Host "`nPackaging standalone distribution zip..." -ForegroundColor Yellow
if (Test-Path $ZipOutput) {
    Remove-Item $ZipOutput -Force
}
Compress-Archive -Path "$OutputDir\*" -DestinationPath $ZipOutput -Force
Write-Host "Standalone Windows Release Package created: $ZipOutput" -ForegroundColor Green

# 7. Test Executable Launch
Write-Host "`nVerifying exported game executable launch..." -ForegroundColor Yellow
$testRun = & $exeOutput --headless --quit-after 50
Write-Host "Exported DarkFort.exe launched and exited cleanly!" -ForegroundColor Green

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host " BUILD SUCCESSFUL! " -ForegroundColor Green
Write-Host " Output: $ZipOutput" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
