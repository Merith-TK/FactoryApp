# Tech Stack

## Engine — Godot 4

**Decision: Godot 4**

### Why Godot

- Native Android export (no Android Studio required for basic deployment)
- Stylus input comes through standard `InputEvent` system — no Samsung SDK needed for basic button detection
- Node-based tree maps naturally to factory graphs (machines as nodes, conveyors as edges)
- GDExtension allows binding Go or C++ for performance-critical simulation
- Moddable via `.pck` files and runtime script loading
- Free, open source, no royalty

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

## Language — GDScript (primary) + Go (optional simulation core)

### GDScript

- Used for: UI, input handling, Godot scene logic, rendering
- Fast iteration, built-in to Godot

### Go (optional, future)

- Used for: deterministic simulation core if GDScript performance is insufficient
- Integrated via **GDExtension** (Go → shared library → Godot)
- Mod system backend could also be Go-based

**Start in GDScript. Port simulation to Go if needed.**

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
| Game logic | GDScript |
| Simulation core (future) | Go via GDExtension |
| Android export | Godot native |
| S Pen button (basic) | Godot InputEvent |
| S Pen remote (advanced) | Samsung S Pen Remote SDK (deferred) |
| Local save | JSON file |
| Server backend | Go + WebSocket + PostgreSQL |
| Mod format | JSON + GDScript / `.pck` |
