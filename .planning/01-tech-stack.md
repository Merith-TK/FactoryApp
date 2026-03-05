# Tech Stack

## Engine — Godot 4

**Decision: Godot 4, pure GDScript. No .NET / C#. No GDExtension linked repos.**

### Why Godot

- Native Android export (no Android Studio required for basic deployment)
- Stylus input comes through standard `InputEvent` system — no Samsung SDK needed for basic button detection
- Node-based tree maps naturally to factory graphs (machines as nodes, conveyors as edges)
- Moddable via `.pck` files and runtime Lua script loading
- Free, open source, no royalty

### Constraints

- **No .NET / C#** — pure GDScript only. Keeps the project dependency-free and Android build simple.
- **No GDExtension linked repos** — no external native libraries that require a separate build step or git submodule. Drop-in precompiled addons (`.gdextension` binaries) are acceptable if they ship as a self-contained asset.
- **No Go simulation core** — original plan to port simulation to Go via GDExtension is dropped. GDScript handles everything. If performance becomes a real issue it will be revisited, but not planned for.

### Stylus in Godot

On Samsung devices, the S Pen side button maps as `MOUSE_BUTTON_RIGHT` (secondary button) through `InputEventScreenDrag` / `InputEventMouseButton`. No Samsung SDK required.

```gdscript
func _input(event):
    if event is InputEventScreenDrag:
        if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
            # S Pen button held while dragging
            pass
```

Advanced remote features (Air Actions, Bluetooth gestures) require the Samsung S Pen Remote SDK (Java/Kotlin layer) — deferred for later if needed.

---

## Language — GDScript (only)

- All game logic, UI, input handling, simulation, and rendering in GDScript
- No C#, no Go, no C++
- Fast iteration, fully portable to Android without extra build steps

---

## Modding — Lua (via LuaAPI addon)

Script mods use **Lua 5.4**, embedded into Godot via the **[LuaAPI](https://github.com/WeaselGames/godot_luaAPI) GDExtension addon**.

- LuaAPI ships as a precompiled `.gdextension` binary — drop into `addons/` folder, no build step, no submodule
- Lua scripts run in a **sandboxed environment** — only the API surface explicitly exposed by the game is accessible
- Mods cannot access the filesystem, network, or Godot internals directly
- See [06-modding.md](./06-modding.md) for full Lua mod API design

---

## Backend (Optional Server Mode)

Two evaluated options:

### Option A — Go Backend (Recommended)

- Language you already know
- WebSocket or HTTP API
- Simulation runs in Go (same core as local mode)
- PostgreSQL for persistence
- Full control, predictable, debuggable

### Option B — SpacetimeDB

- Logic-in-DB model (compute runs inside the database)
- Designed for game state replication
- Built-in multiplayer delta sync
- Less mature tooling, more magic

**Recommendation:** Start local-only. Build Go backend later if server saves / multiplayer become priority. SpacetimeDB is worth revisiting once the simulation core is stable.

---

## Summary

| Layer | Technology |
|---|---|
| Engine | Godot 4 |
| Game logic | GDScript (only) |
| Mod scripting | Lua 5.4 via LuaAPI addon |
| Android export | Godot native |
| S Pen button (basic) | Godot InputEvent |
| S Pen remote (advanced) | Samsung S Pen Remote SDK (deferred) |
| Local save | SQLite via godot-sqlite addon |
| Server backend | Go + WebSocket + PostgreSQL |
| Mod format | JSON (data) + Lua (scripts) + `.pck` (assets) |
