# Modding System

## Goals

- Allow adding new machines, items, and recipes without modifying base game
- Allow scripting custom machine behavior
- Keep mod format simple enough that a JSON file is enough for basic content

---

## Mod Layers

| Layer | Description |
|---|---|
| **Data mods** | JSON files defining machines, items, recipes — no code required |
| **Script mods** | GDScript files defining custom logic (e.g., machine behavior overrides) |
| **Pack mods** | `.pck` files (Godot resource packs) containing assets + scripts |

---

## Data Mod Format

### Item Definition

```json
{
  "id": "copper_ingot",
  "display_name": "Copper Ingot",
  "icon": "res://mods/mymod/icons/copper_ingot.png",
  "stack_size": 50
}
```

### Machine Definition

```json
{
  "id": "copper_smelter",
  "display_name": "Copper Smelter",
  "size": [2, 2],
  "sprite": "res://mods/mymod/sprites/copper_smelter.png",
  "input_ports": [
    { "local_position": [-1, 0], "direction": [-1, 0] }
  ],
  "output_ports": [
    { "local_position": [1, 0], "direction": [1, 0] }
  ],
  "recipes": ["smelt_copper"],
  "power_consumption": 10
}
```

### Recipe Definition

```json
{
  "id": "smelt_copper",
  "inputs": { "copper_ore": 1 },
  "outputs": { "copper_ingot": 1 },
  "ticks": 15
}
```

---

## Script Mods (GDScript)

For custom machine behavior beyond what recipes cover:

```gdscript
# mods/mymod/machines/sorter.gd
extends MachineBase

func on_tick(state: MachineState) -> void:
    # Custom tick logic
    pass
```

GDScript mods are loaded at runtime via `load()` / `ResourceLoader`.

---

## Pack Mods (.pck)

Godot `.pck` files can bundle:
- Images/sprites
- JSON data files
- GDScript files

Loaded at startup or at runtime via:

```gdscript
ProjectSettings.load_resource_pack("user://mods/mymod.pck")
```

All assets inside become available under `res://mods/mymod/...`.

---

## Mod Loading Order

1. Base game content loaded from `res://data/`
2. Mods loaded from `user://mods/` in alphabetical order (or user-defined order)
3. Later mods can override earlier definitions by sharing the same `id`
4. Conflicts logged to console

---

## Mod Manifest

Each mod has a `mod.json` at its root:

```json
{
  "id": "mymod",
  "name": "My Factory Mod",
  "version": "1.0.0",
  "author": "author name",
  "dependencies": [],
  "load_order": 100
}
```

---

## Future: Lua / WASM Embedding

If GDScript mods are too powerful (security concern for server play) or too limited:

- Embed **Lua** or a sandboxed **WASM** runtime in Go simulation core
- Mods run in sandbox with defined API surface
- Prevents unsafe mod code from affecting server

**Status: Post-MVP consideration.**

---

## Mod Distribution (Future)

- Manual install via file manager (`.pck` drop into mods folder)
- In-game mod browser (post-MVP)
- GitHub-based registry (post-MVP)
