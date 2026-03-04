# Milestones & Roadmap

## Milestone 0 — Prototype (Current Goal)

Prove the core loop is fun and working.

- [ ] Godot 4 project set up, Android export working
- [ ] Stylus input detected (position, button state)
- [ ] Software toggle button (fallback)
- [ ] Canvas panning and zooming
- [ ] Place a machine (placeholder sprite) with rotation
- [ ] Draw a conveyor line between two machines
- [ ] Basic simulation tick (items move through conveyors)
- [ ] Local save / load (JSON)

**Definition of done:** Can place two machines, connect them with a conveyor, and watch items flow. Save and reload the state.

---

## Milestone 1 — Playable Core

- [ ] Multiple machine types loaded from JSON definitions
- [ ] Multiple item types and recipes
- [ ] Analysis overlay (flow rates, bottlenecks)
- [ ] Grid snap toggle
- [ ] Erase mode
- [ ] Context radial menu (delete, inspect)
- [ ] Proper port validation (output → input only)
- [ ] Auto-snap conveyor to ports

**Definition of done:** A simple production chain (ore → ingot → plate) is buildable from scratch using only a stylus.

---

## Milestone 2 — Polish & Moddability

- [ ] Data mod loading from `user://mods/`
- [ ] `.pck` mod support
- [ ] Power system (production, consumption, stall)
- [ ] Multiple save slots
- [ ] Settings panel (snap options, tick rate, etc.)
- [ ] Proper sprites and audio

---

## Milestone 3 — Cloud Sync (Server Save, Single User)

- [ ] Go backend with WebSocket
- [ ] Authentication / login system (protects save data from unauthorized access)
- [ ] Server-authoritative simulation
- [ ] Same save accessible from multiple personal devices
- [ ] PostgreSQL persistence
- [ ] Conflict resolution (last-writer-wins or tick-based)

---

## Milestone 4 — Co-op (Shared Factory)

- [ ] Shared factory session between 2–4 players
- [ ] Permission model (who can build/delete/reconfigure)
- [ ] Delta sync optimized for multiple connected clients
- [ ] Session invite system

---

## Milestone 5 — Public Worlds (Maybe)

- [ ] Persistent servers others can discover and join
- [ ] Role/permission tiers
- [ ] SpacetimeDB re-evaluation at this stage

---

## Deferred / Not In Scope (MVP)

- Samsung S Pen Remote SDK (Bluetooth remote events / Air Actions)
- Desktop port
- In-game mod browser
- 3D or isometric view
- Character / avatar
- Combat or threat systems
- Custom conveyor visual routing (bezier stays, or auto-straighten TBD)
