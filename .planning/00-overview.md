# FactoryApp — Project Overview

## Vision

A **stylus-first, moddable factory game** for Android (Samsung S Pen primary target), designed to be fully playable with nothing more than a stylus — no touch gestures required, no character-centric gameplay, no cluttered UI.

Think: **engineering notebook meets Satisfactory.**

---

## Core Design Pillars

1. **Stylus Native** — The S Pen (or any stylus) is the primary input device. Mouse/touch is secondary. No finger-sized buttons.
2. **Sketch to Build** — You draw/sketch your factory onto the map. Conveyors are drawn as lines. Buildings are placed via drones.
3. **Drone, Not Avatar** — You control one or more **construction drones**. No hand-holding a character. Assign tasks, drones execute. You focus one drone at a time.
4. **Proximity Matters** — A drone must be physically near a building to construct, gather from, or deposit into it. Configuration and planning is remote.
5. **Minimal UI** — No toolbars. Mode switching via pen button or on-screen toggles. Radial menus for context actions.
6. **Moddable** — JSON-defined machines/items, loadable `.pck` packs, scriptable behavior.
7. **Offline First, Server Optional** — Works fully locally. Optional server-authoritative backend for cloud saves / multiplayer.

---

## What This Game Is NOT

- Not a Factorio clone in feel (no walking character, no combat — hazards exist but don't kill)
- Not a touch-first mobile game
- Not a real-time action game
- Not reliant on toolbar-heavy UI

---

## Target Platform

- **Primary:** Android (Samsung Galaxy Tab / S Pen devices)
- **Secondary:** Android (non-S Pen, touch fallback buttons)
- **Future:** Desktop parity possible via Godot's export system

## View / Perspective

**Starting with 2D top-down.** Revisit isometric or 3D once core loop is proven. Top-down is the safe default for stylus clarity and performance.

---

## High-Level Feature List

| Feature | Status |
|---|---|
| Stylus + S Pen input | Planning |
| Freeform sketch conveyor placement | Planning |
| Machine placement (rotation + IO faces) | Planning |
| Optional grid snap | Planning |
| Analysis / diagnostic overlay | Planning |
| Construction drone (player entity) | Planning |
| Drone task assignment (auto-pathfinding) | Planning |
| Multiple drones (mid-to-late unlock) | Planning |
| Drone focus system (one active at a time) | Planning |
| Inventory system (drone carries items) | Planning |
| Hazard zones (block navigation/production) | Planning |
| Resource deposits (seed-based, infinite) | Planning |
| Automated harvesters | Planning |
| Production chains (ore → components → advanced) | Planning |
| Mission system (game-driven production targets) | Planning |
| Tech tree — HUB milestones (linear, main path) | Planning |
| Tech tree — Research Lab (branching, optional) | Planning |
| Power grid (generators, lines, machines) | Planning |
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
- [07-milestones.md](./07-milestones.md) — Roadmap and milestone checklist
- [08-player-drone.md](./08-player-drone.md) — Construction drone system, inventory, tasks, hazards
- [09-gameplay-loop.md](./09-gameplay-loop.md) — Resource flow, missions, tech tree, progression pacing
- [10-world-generation.md](./10-world-generation.md) — Two world types (chunk-based vs pre-gen), performance comparison
- [11-base-content.md](./11-base-content.md) — Machine catalog, production chain, base items
- [02-input-system.md](./02-input-system.md) — Stylus / S Pen input handling
- [03-ux-design.md](./03-ux-design.md) — Interaction model, modes, UI approach
- [04-simulation.md](./04-simulation.md) — Core simulation architecture
- [05-save-system.md](./05-save-system.md) — Local and server save design
- [06-modding.md](./06-modding.md) — Mod system design
