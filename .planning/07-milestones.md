# Milestones & Roadmap

## Milestone 0 — Prototype (Current Goal)

Prove the core loop is fun and working.

- [ ] Godot 4 project set up, Android export working
- [ ] Stylus input detected (position, button state)
- [ ] Software toggle button (fallback)
- [ ] Canvas panning and zooming
- [ ] Construction drone entity on the map (placeholder sprite)
- [ ] Drone auto-pathfinds to assigned task location
- [ ] Drone inventory (carries items)
- [ ] Place a machine (placeholder sprite) with rotation — drone must be in range
- [ ] Draw a conveyor line between two machines
- [ ] Basic simulation tick (items move through conveyors)
- [ ] Local save / load (JSON)

**Definition of done:** Can assign a drone to construct two machines, connect them with a conveyor, watch items flow, and save/reload the state.

---

## Milestone 1 — Playable Core

- [ ] Multiple machine types loaded from JSON definitions
- [ ] Multiple item types and recipes
- [ ] Drone task queue UI (assign, view, cancel tasks)
- [ ] Drone inventory management (gather, deposit, carry limit)
- [ ] Proximity enforcement (drone must be in range to construct/gather/deposit)
- [ ] Remote configuration (machine settings accessible from map view regardless of drone position)
- [ ] **Power grid** — generators, power lines (drawn in sketch mode), machines stall without power
- [ ] **Drone power modes** — internal (baseline) vs grid-connected (boosted stats)
- [ ] Drone internal power drain + recharge near powered structures
- [ ] Hazard zones (block drone navigation and production until cleared)
- [ ] **Resource deposits** — seed-placed infinite deposits, harvester machine
- [ ] Analysis overlay (flow rates, bottlenecks, power network)
- [ ] Grid snap toggle
- [ ] Erase mode
- [ ] Context radial menu (delete, inspect, configure)
- [ ] Proper port validation (output → input only)
- [ ] Auto-snap conveyor to ports

**Definition of done:** A simple ore → ingot → plate production chain is buildable from a live resource deposit, powered by a generator, using only a stylus.

---

## Milestone 2 — Polish & Moddability

- [ ] Data mod loading from `user://mods/`
- [ ] `.pck` mod support
- [ ] **Mission system** — game-driven production targets, mission definitions in JSON
- [ ] **HUB milestone tech tree** — linear tier unlocks gated by mission completion
- [ ] **Research Lab** — branching optional research, resource-fed, drone/logistics upgrades
- [ ] Multiple save slots
- [ ] Settings panel (snap options, tick rate, etc.)
- [ ] Proper sprites and audio
- [ ] Multiple drone support (unlock via progression)
- [ ] Drone focus system (tap to switch, others continue task queues)
- [ ] Hazard clearance tasks (assign drone to clear a zone)

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
- Combat (drones face hazards but cannot die — hazards are gates, not threats)
- Custom conveyor visual routing (bezier stays, or auto-straighten TBD)
- Power grid islands / circuit breaker logic (basic grid only for MVP)
