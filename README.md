# 🏰 Dark Fort: Lost Treasure

A complete 3D third-person adventure game built in **Godot 4** using **GDScript** and the lightweight **Compatibility (OpenGL / GLES3)** renderer. Optimized specifically for smooth 60 FPS performance on Intel integrated graphics and 8 GB RAM systems, with future Android export readiness.

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
| **Look / Rotate** | Mouse Movement | Full 3D camera orbit with pitch limits |
| **Sprint** | `Shift` | Dash / sprint at high speed |
| **Jump** | `Space` | Jump over obstacles |
| **Interact** | `E` | Activate rune pillars, collect key, unlock chest |
| **Cursor / Pause**| `Esc` | Toggle mouse capture / pause |

---

## 🏗️ Technical Architecture & Directory Structure

```
dark-fort/
├── .github/
│   └── workflows/
│       └── game-ci.yml           # Automated CI/CD test runner workflow
├── build/                        # Local release export directory (git-ignored)
├── materials/                    # Shared StandardMaterial3D resources
│   ├── mat_stone_wall.tres       # Weathered stone walls & towers
│   ├── mat_ground.tres           # Courtyard flagstones
│   ├── mat_iron.tres             # Portcullis & trap grating
│   ├── mat_wood.tres             # Chest structure & torch poles
│   ├── mat_gold.tres             # Key & Lost Treasure materials
│   ├── mat_rune_off.tres         # Dormant rune stones
│   ├── mat_rune_on.tres          # Glowing cyan emissive runes
│   ├── mat_fire.tres             # Torch flame material
│   ├── mat_danger.tres           # Red warning trap spikes
│   └── mat_player.tres           # Adventurer cloak & tunic
├── scenes/
│   ├── player/
│   │   └── player.tscn           # Third-person visible player with torch & camera
│   ├── props/
│   │   ├── chest.tscn            # Animated treasure chest with gold particles
│   │   ├── door.tscn             # Animated iron portcullis gate
│   │   ├── key_item.tscn         # Floating, rotating gold key
│   │   ├── puzzle_pillar.tscn    # Interactive rune obelisks
│   │   ├── torch.tscn            # Wall sconce with procedural flicker
│   │   └── trap.tscn             # Periodic floor spike trap
│   └── ui/
│       ├── hud.tscn              # Health bar, objective tracker, key badge, prompt
│       ├── win_ui.tscn           # Victory screen & replay button
│       └── game_over_ui.tscn     # Death screen & retry button
├── scripts/
│   ├── managers/
│   │   └── game_manager.gd       # Central game state Autoload singleton
│   ├── player/
│   │   └── player.gd             # Smooth 3D third-person controller
│   ├── props/                    # Prop interaction and logic scripts
│   ├── ui/                       # UI event listeners & animations
│   └── build_windows.ps1         # 1-click Windows PCK export script
├── tests/
│   ├── test_gameplay.gd          # Headless automated unit & integration tests
│   └── test_gameplay.tscn        # Test runner scene
├── export_presets.cfg            # Windows Desktop & Android export configurations
├── project.godot                 # Godot project settings & input mappings
└── main.tscn                     # Complete, fully assembled playable level
```

---

## ⚡ Performance Optimizations for Low-End Hardware

- **Compatibility Renderer (GL Compatibility)**: Uses lightweight OpenGL 3 / WebGL 2 shaders suitable for Intel HD / UHD integrated graphics.
- **Zero Directional Shadow Bottlenecks**: Heavy shadow maps disabled; atmospheric depth provided through baked-style ambient coloring, procedural midnight fog, and selective point light attenuation.
- **CPU Particles (`CPUParticles3D`)**: Eliminates GPU compute shader requirements so sparks and sparkles run at 60+ FPS on all machines.
- **Procedural / Primitive Geometry**: Clean modular boxes, cylinders, and capsules avoid bloated mesh overhead and eliminate external 3D modeling software requirements.

---

## 🧪 Automated Testing

An automated headless gameplay test suite is included in `tests/test_gameplay.tscn`. It validates:
- [x] Initial game state and player stats (100 HP, 0 keys, puzzle unsolved)
- [x] 3-Rune puzzle logic and gate opening signal
- [x] Key collection and inventory tracking
- [x] Spike trap damage and death/game over conditions
- [x] Treasure chest opening and win victory condition
- [x] Complete node hierarchy verification in `main.tscn`

To run the automated test suite locally:
```powershell
& "<path-to-godot-console.exe>" --headless --path . "res://tests/test_gameplay.tscn"
```

---

## 📦 Building the Game

### Windows Desktop Build
Run the automated build script:
```powershell
powershell -ExecutionPolicy Bypass -File "scripts/build_windows.ps1"
```
The output package will be created in `build/windows/DarkFort.pck`.

### Android Build
An Android export preset is pre-configured in `export_presets.cfg` (`org.godotengine.darkfort`) targeting `arm64-v8a`.
