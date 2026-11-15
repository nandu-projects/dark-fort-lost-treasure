# 🏰 Dark Fort: Lost Treasure (v0.1)

A complete 3D third-person adventure game built in **Godot 4.7.2** using **GDScript** and the lightweight **Compatibility (OpenGL 3.3 / GLES3)** renderer. Optimized specifically for smooth 60 FPS performance on Intel integrated graphics and 8 GB RAM systems, with future Android export readiness.

[![Dark Fort CI / CD](https://img.shields.io/badge/CI%2FCD-Ready-brightgreen)](https://github.com/nandu-projects/dark-fort-lost-treasure)
[![Release](https://img.shields.io/badge/Release-v0.1-gold)](https://github.com/nandu-projects/dark-fort-lost-treasure/releases)
[![Tests](https://img.shields.io/badge/Tests-47%20Passed-blue)](https://github.com/nandu-projects/dark-fort-lost-treasure)

---

## 🎮 Game Overview

You arrive at the mist-shrouded ruins of an ancient abandoned fort. Deep beneath its cobblestone courtyard lies a sealed underground vault said to hold the legendary Lost Relics of Dark Fort.

To claim the treasure, you must:
1. **Explore the Fort Courtyard** — Navigate the weathered stone ramparts and four watchtowers.
2. **Channel the 3 Ancient Runes** — Discover and activate the Sun, Moon, and Star rune pillars across the fort.
3. **Unseal the Iron Portcullis** — The solved puzzle automatically raises the massive iron gate blocking the underground descent.
4. **Locate the Ancient Gold Key** — Find the floating golden key resting upon the sacrificial stone altar.
5. **Survive the Catacombs & Spikes** — Navigate the narrow subterranean tunnel and time your movement to avoid deadly floor spike traps.
6. **Unlock the Vault & Claim the Lost Treasure** — Use the Ancient Key to open the glowing golden chest and win the game!

---

## 🕹️ Controls

| Action | Keyboard / Mouse | Description |
| :--- | :--- | :--- |
| **Move** | `W`, `A`, `S`, `D` / Arrow Keys | Move adventurer relative to camera |
| **Look / Orbit** | Mouse Movement | Full 3D camera orbit with pitch limits |
| **Sprint** | `Shift` | Dash / sprint at high speed |
| **Jump** | `Space` | Jump over obstacles |
| **Interact** | `E` | Activate rune pillars, collect key, unlock chest |
| **Cursor / Pause**| `Esc` | Toggle mouse capture / pause |

---

## 🚀 Playing the Game on Windows

### Option 1: Standalone Release (Recommended)
1. Download `DarkFort-v0.1-Windows.zip` from the [GitHub Releases](https://github.com/nandu-projects/dark-fort-lost-treasure/releases/tag/v0.1).
2. Extract the ZIP file to any folder.
3. Double-click **`DarkFort.exe`** to start playing!
   *(The package includes the signed release executable and all compiled game assets in `DarkFort.pck`)*.

### Option 2: Running in Godot 4 Editor
1. Open Godot 4.7.2.
2. Click **Import**, browse to `project.godot` inside this repository.
3. Press **Run Project (`F5`)**.

---

## 🧪 Comprehensive Automated Testing

The game includes two automated test suites with **47 total tests (0 failures)**:

### 1. Headless Gameplay & State Unit Test Suite (29 Tests)
Tests state transitions, signal propagation, key inventory, rune puzzle logic, trap damage, and node hierarchy.
```powershell
& "<path-to-godot-console.exe>" --headless --path . "res://tests/test_gameplay.tscn"
```

### 2. Live Simulation & Visual Screenshot Suite (18 Tests)
Runs live physics steps in an active viewport, tests player movement vectors, camera orbits, gate tweens, HUD health bar updates, and captures graphical screenshots:
```powershell
& "<path-to-godot-console.exe>" --path . "res://tests/test_simulation.tscn"
```
Generated visual proof screenshots are saved in `tests/screenshots/`:
- `step1_courtyard.png` — Player & courtyard rendering
- `step2_puzzle_solved.png` — Activated rune crystal glow & open portcullis
- `step3_key_collected.png` — Key pickup & HUD badge
- `step4_tunnel_trap.png` — Spike trap damage & HUD health bar drop
- `step5_treasure_win.png` — Chest opening tween, golden particles & Win UI
- `step6_game_over.png` — Lethal damage & Game Over screen

---

## 🏗️ 1-Click Windows Build Automation

To rebuild the standalone Windows game and package the distribution ZIP:
```powershell
powershell -ExecutionPolicy Bypass -File "scripts/build_windows.ps1"
```
This script automatically:
1. Runs all 29 unit tests.
2. Runs all 18 live simulation checks.
3. Compiles game resources into `build/windows/DarkFort.pck`.
4. Assembles the signed standalone `DarkFort.exe`.
5. Generates the release package: `build/DarkFort-v0.1-Windows.zip`.
6. Executes a launch test of the exported binary.

---

## 📱 Android Export Status & Requirements

An Android export preset is configured in `export_presets.cfg` (`org.godotengine.darkfort`, architecture `arm64-v8a`).

### Verified System Prerequisites:
- ✅ **Java JDK**: OpenJDK 17 (`Microsoft jdk-17.0.10.7-hotspot`) is installed.
- ✅ **Android SDK**: Located at `C:\Users\nandan m\AppData\Local\Android\Sdk`.
- ✅ **Keystore**: Godot debug keystore is generated at `C:\Users\nandan m\AppData\Roaming\Godot\keystores\debug.keystore`.

### To Complete Android Export:
Install the Godot 4.7.2 Android export templates (`android_debug.apk` and `android_release.apk`) in Godot via **Editor → Manage Export Templates**, then run:
```powershell
& "<path-to-godot-console.exe>" --headless --path . --export-release "Android" build/android/DarkFort.apk
```

---

## ⚙️ Performance Optimizations for Low-End Systems

- **Compatibility Renderer (OpenGL 3.3 / GLES3)**: Designed for Intel HD / UHD integrated graphics.
- **Optimized Lighting**: Dynamic directional shadow maps are disabled to avoid GPU fill rate bottlenecks; atmospheric lighting uses balanced ambient color, procedural night sky, and localized point lights.
- **CPU Particles (`CPUParticles3D`)**: Eliminates heavy GPU compute shader overhead for sparks and gold particles.
- **Modular Collision Geometry**: Uses fast Box, Cylinder, and Capsule shapes without complex trimeshes.
