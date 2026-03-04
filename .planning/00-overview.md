# FactoryApp — Project Overview

## Vision

A **stylus-first, moddable factory game** for Android (Samsung S Pen primary target), designed to be fully playable with nothing more than a stylus — no touch gestures required, no character-centric gameplay, no cluttered UI.

Think: **engineering notebook meets Satisfactory.**

---

## Core Design Pillars

1. **Stylus Native** — The S Pen (or any stylus) is the primary input device. Mouse/touch is secondary. No finger-sized buttons.
2. **Sketch to Build** — You draw/sketch your factory onto the map. Conveyors are drawn as lines. Buildings are placed by tapping.
3. **No Avatar** — No character. No walking. Pure top-down engineering view.
4. **Minimal UI** — No toolbars. Mode switching via pen button or on-screen toggles. Radial menus for context actions.
5. **Moddable** — JSON-defined machines/items, loadable `.pck` packs, scriptable behavior.
6. **Offline First, Server Optional** — Works fully locally. Optional server-authoritative backend for cloud saves / multiplayer.

---

## What This Game Is NOT

- Not a Factorio clone (no character, no combat)
- Not a touch-first mobile game
- Not a character-with-tools simulator
- Not reliant on toolbar-heavy UI

---

## Target Platform

- **Primary:** Android (Samsung Galaxy Tab / S Pen devices)
- **Secondary:** Android (non-S Pen, touch fallback buttons)
- **Future:** Desktop parity possible via Godot's export system

---

## High-Level Feature List

| Feature | Status |
|---|---|
| Stylus + S Pen input | Planning |
| Freeform sketch conveyor placement | Planning |
| Machine placement (rotation + IO faces) | Planning |
| Optional grid snap | Planning |
| Analysis / diagnostic overlay | Planning |
| Local save (JSON) | Planning |
| Server save (authoritative backend) | Planning |
| Mod system (JSON + scripts) | Planning |

---

## Related Planning Documents

- [01-tech-stack.md](./01-tech-stack.md) — Engine, language, backend choices
- [02-input-system.md](./02-input-system.md) — Stylus / S Pen input handling
- [03-ux-design.md](./03-ux-design.md) — Interaction model, modes, UI approach
- [04-simulation.md](./04-simulation.md) — Core simulation architecture
- [05-save-system.md](./05-save-system.md) — Local and server save design
- [06-modding.md](./06-modding.md) — Mod system design
