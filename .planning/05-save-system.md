# Save System

## Overview

Two save modes supported:

| Mode | Description |
|---|---|
| **Local Save** | JSON file on device, fully offline, simulation runs locally |
| **Server Save** | Server is source of truth, state synced from server, simulation authoritative |

The same simulation core runs in both modes. The save format is identical.

---

## Save Format (JSON)

Saves are pure state — fully reconstructible. No transient or frame-state data.

```json
{
  "version": 1,
  "tick": 123456,
  "machines": [
    {
      "id": "uuid",
      "type": "smelter",
      "position": [100.0, 200.0],
      "rotation": 0.0,
      "inventory": { "iron_ore": 5 }
    }
  ],
  "conveyors": [
    {
      "id": "uuid",
      "source_port": "port_uuid",
      "dest_port": "port_uuid",
      "capacity": 1.0
    }
  ],
  "power_nodes": []
}
```

Rules:
- No floating point randomness
- No time-of-day or real-world timestamps in simulation state
- All IDs are UUIDs
- Tick counter is deterministic clock

---

## Local Save

- Saved to device storage as `saves/<name>.json`
- Auto-save on pause / background / interval (every N ticks)
- Manual save option in menu
- Multiple save slots supported
- Export/import save file for backup or sharing

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
- PostgreSQL stores full state JSON per save slot

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

1. **Local JSON save** (MVP — required first)
2. **Server-authoritative single player** (cloud save, same machine)
3. **Server multiplayer** (shared factory — post-MVP)

Do not attempt server-first. Simulation stability must come first.
