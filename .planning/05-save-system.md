# Save System

## Overview

Four save modes, implemented in priority order:

| Priority | Mode | Description |
|---|---|---|
| 1 | **Local Save** | SQLite file on device, fully offline |
| 2 | **Cloud Sync** | Same save across your own devices via login, server holds canonical state |
| 3 | **Co-op** | Shared factory with friends (2–4 players) |
| 4 | **Public Worlds** | Persistent servers others can join (maybe, post-MVP) |

The same simulation core runs in all modes. The save format is identical.

**Authentication is required for all server modes.** Login system ensures only authorized users can read or modify a save. No anonymous connections to save servers.

---

## Save Format — SQLite

**Library:** [godot-sqlite](https://github.com/2shady4u/godot-sqlite) — precompiled GDExtension addon, drop-in, no build step.

The save is a single `.db` file. All world state is stored relationally. Saves are written as **atomic transactions** — no partial/corrupt saves.

### Why SQLite over JSON

- World state is inherently relational (machines have ports, ports have conveyors, conveyors have items)
- JSON becomes a deeply nested blob that must be fully deserialized to read anything
- SQLite lets you load only what you need (e.g., just machines in a viewport region)
- Atomic transactions mean a crash mid-save does not corrupt the file
- Schema maps directly to PostgreSQL on the server — same queries, same structure
- Single `.db` file is easy to export, backup, and share

### Schema

```sql
-- World metadata
CREATE TABLE meta (
    key   TEXT PRIMARY KEY,
    value TEXT
);
-- Stores: seed, tick, world_type, world_size_x, world_size_y

-- Placed machines
CREATE TABLE machines (
    id       TEXT PRIMARY KEY,
    type     TEXT NOT NULL,
    pos_x    REAL NOT NULL,
    pos_y    REAL NOT NULL,
    rotation REAL NOT NULL,
    state    TEXT NOT NULL  -- idle, running, starved, blocked, unpowered
);

-- Machine inventory
CREATE TABLE machine_inventory (
    machine_id TEXT NOT NULL,
    item_id    TEXT NOT NULL,
    quantity   INTEGER NOT NULL,
    PRIMARY KEY (machine_id, item_id)
);

-- Conveyors
CREATE TABLE conveyors (
    id          TEXT PRIMARY KEY,
    source_port TEXT NOT NULL,
    dest_port   TEXT NOT NULL,
    capacity    REAL NOT NULL
);

-- Conveyor path points (ordered)
CREATE TABLE conveyor_path (
    conveyor_id TEXT NOT NULL,
    seq         INTEGER NOT NULL,
    pos_x       REAL NOT NULL,
    pos_y       REAL NOT NULL,
    PRIMARY KEY (conveyor_id, seq)
);

-- Items currently on conveyors
CREATE TABLE conveyor_items (
    id          TEXT PRIMARY KEY,
    conveyor_id TEXT NOT NULL,
    item_type   TEXT NOT NULL,
    progress    REAL NOT NULL  -- 0.0 (source) to 1.0 (dest)
);

-- Drones
CREATE TABLE drones (
    id                 TEXT PRIMARY KEY,
    pos_x              REAL NOT NULL,
    pos_y              REAL NOT NULL,
    state              TEXT NOT NULL,
    internal_power     REAL NOT NULL,
    grid_connected     INTEGER NOT NULL  -- 0 or 1
);

-- Drone inventory
CREATE TABLE drone_inventory (
    drone_id  TEXT NOT NULL,
    item_id   TEXT NOT NULL,
    quantity  INTEGER NOT NULL,
    PRIMARY KEY (drone_id, item_id)
);

-- Drone task queue (ordered)
CREATE TABLE drone_tasks (
    id             TEXT PRIMARY KEY,
    drone_id       TEXT NOT NULL,
    seq            INTEGER NOT NULL,
    type           TEXT NOT NULL,  -- construct, demolish, gather, deposit, clear_hazard
    target_pos_x   REAL,
    target_pos_y   REAL,
    target_id      TEXT
);

-- Power nodes
CREATE TABLE power_nodes (
    id          TEXT PRIMARY KEY,
    machine_id  TEXT NOT NULL,
    role        TEXT NOT NULL,  -- producer, consumer, both
    production  REAL NOT NULL,
    consumption REAL NOT NULL
);

-- Power lines
CREATE TABLE power_lines (
    id       TEXT PRIMARY KEY,
    node_a   TEXT NOT NULL,
    node_b   TEXT NOT NULL,
    capacity REAL NOT NULL
);

-- Resource deposits (or regenerated from seed — TBD)
CREATE TABLE resource_deposits (
    id            TEXT PRIMARY KEY,
    resource_type TEXT NOT NULL,
    pos_x         REAL NOT NULL,
    pos_y         REAL NOT NULL,
    is_active     INTEGER NOT NULL  -- 0 if blocked by hazard
);

-- Hazard zones
CREATE TABLE hazard_zones (
    id      TEXT PRIMARY KEY,
    type    TEXT NOT NULL,
    cleared INTEGER NOT NULL,
    area    TEXT NOT NULL  -- JSON-encoded polygon points (small, acceptable here)
);
```

### Save Rules

- No floating point randomness in simulation state
- All IDs are UUIDs (TEXT)
- Tick counter stored in `meta` table
- Every write wrapped in a transaction — partial saves cannot occur
- Auto-save runs as a background transaction every N ticks (non-blocking)

---

## Local Save

- Saved to device storage as `user://saves/<name>.db`
- Auto-save via background transaction every N ticks (non-blocking, no stutter)
- Manual save option in menu
- Multiple save slots supported
- Export/import `.db` file for backup or sharing

---

## Server Save

### Architecture

```
Client → Send Action (e.g., PlaceMachine)
Server → Validate Action
Server → Apply to SimulationCore
Server → Run Simulation Tick
Server → Broadcast delta state to clients
Client → Apply delta → Render
```

The server holds the canonical state. Clients are thin — they send actions and receive state updates.

### Backend Options

See [01-tech-stack.md](./01-tech-stack.md) for full evaluation.

**Recommended: Go backend + WebSocket + PostgreSQL**

- Go simulation core (matches local mode)
- WebSocket for real-time delta pushes
- PostgreSQL stores world state using the **same schema as the local SQLite db** — direct structural parity, minimal adapter code

**Alternative: SpacetimeDB** — logic-in-DB model, built for game state. More magic, less control. Revisit post-MVP.

### Sync Protocol (Sketch)

```
Connect → Server sends full state snapshot
PlaceAction → Server replies ACK or NACK
TickDelta → Server broadcasts {tick, changed_machines, changed_conveyors}
Disconnect → Local cache maintained for reconnect
```

---

## Determinism Requirements

For server authority to work cleanly:

- Fixed tick rate (10 ticks/sec)
- All randomness seeded (seed stored in save)
- No `Time.get_ticks_msec()` or frame-delta in simulation math
- Floating point operations must be identical across client/server (same platform risks — use integer math where possible for critical simulation values)

---

## Implementation Order

1. **Local SQLite save** (MVP — required first)
2. **Server-authoritative single player** (cloud save, same machine)
3. **Server multiplayer** (shared factory — post-MVP)

Do not attempt server-first. Simulation stability must come first.
