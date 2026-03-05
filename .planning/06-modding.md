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
| **Script mods** | Lua 5.4 files defining custom logic (e.g., machine behavior, events) |
| **Pack mods** | `.pck` files (Godot resource packs) containing assets + JSON + Lua |

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

## Script Mods (Lua 5.4)

Custom machine behavior and event hooks are written in **Lua 5.4**, sandboxed via the LuaAPI Godot addon.

### Why Lua

- Sandboxed by default — mods only access what the game explicitly exposes
- Safe for server-authoritative mode (no arbitrary filesystem/network access)
- Lightweight, fast, widely known in the modding community
- No .NET, no GDExtension build step — fits pure Godot constraint

### Lua Mod API (Exposed Surface)

The game exposes a controlled API to Lua. Mods call these functions; they cannot call anything else.

```lua
-- Called every simulation tick while machine is running
function on_tick(machine)
    local inv = machine:get_inventory()
    if inv:count("iron_ore") >= 2 then
        inv:remove("iron_ore", 2)
        inv:add("iron_ingot", 1)
    end
end

-- Called when a machine is placed
function on_place(machine)
    machine:set_state("idle")
end

-- Called when a machine is removed
function on_remove(machine)
end
```

### Exposed API Objects

| Object | Methods |
|---|---|
| `machine` | `get_inventory()`, `set_state()`, `get_state()`, `get_id()`, `get_type()` |
| `inventory` | `count(item_id)`, `add(item_id, qty)`, `remove(item_id, qty)`, `has(item_id, qty)` |
| `game` | `get_tick()`, `log(msg)` |

Explicitly **NOT** exposed to Lua:
- Filesystem access
- Network access
- Godot engine internals
- Other machines (no cross-machine API in scripts — that’s the simulation graph’s job)

### Lua Script in mod.json

Machines reference their Lua script in the machine definition:

```json
{
  "id": "custom_sorter",
  "script": "mods/mymod/scripts/sorter.lua",
  ...
}
```

If no script is specified, the machine uses the default recipe-based behavior.

---

## Pack Mods (.pck)

Godot `.pck` files can bundle:
- Images/sprites
- JSON data files
- Lua script files

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

## Lua Runtime Notes

- **Library:** [LuaAPI](https://github.com/WeaselGames/godot_luaAPI) — Lua 5.4 embedded in Godot 4 as a precompiled GDExtension addon. Drop into `addons/luaAPI/`, no build step.
- Each machine with a Lua script gets its **own Lua state** — no shared globals between mods
- Lua errors are caught and logged; they do not crash the game
- Lua scripts are loaded once at mod load time, not re-parsed every tick

---

## Mod Distribution (Future)

- Manual install via file manager (`.pck` drop into mods folder)
- In-game mod browser (post-MVP)
- GitHub-based registry (post-MVP)
