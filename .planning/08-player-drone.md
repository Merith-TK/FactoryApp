# Player — Construction Drone

## Concept

There is no traditional player character. Instead, you control one or more **Construction Drones** — autonomous units that carry inventory, construct buildings, and interact with machines in the world on your behalf.

You assign tasks. The drone executes them.

---

## Core Rules

| Rule | Description |
|---|---|
| **Proximity required for physical actions** | A drone must be within range of a building to construct it, gather from it, or deposit into it |
| **Remote configuration allowed** | Machine recipes, settings, conveyor routing — all manageable from the map view without drone proximity |
| **One focus at a time** | You can only actively control/command one drone at a time. Others continue executing their task queue. |
| **One drone at game start** | You begin with a single drone |
| **More drones = mid/late game unlock** | Additional drones are built or unlocked as factory progression reward |

---

## Drone Power System

The drone has its **own internal power source** — it always functions to some degree. However, being connected to the factory power grid unlocks boosted capabilities.

### Two Power Modes

| Mode | Condition | Effect |
|---|---|---|
| **Internal** | No powered structure in range | Baseline stats — limited range, slower movement, slower build |
| **Grid-Connected** | Within range of a powered structure | Boosted stats — larger build range, faster movement, faster build speed |

This creates an organic incentive: **extend your power grid outward as you expand**, so your drone is always boosted when working at the frontier.

### Drone Power Stats

| Stat | Internal Mode | Grid-Connected Mode |
|---|---|---|
| Build range radius | Small | Large |
| Movement speed | Normal | Fast |
| Construction speed | Normal | Fast |
| Gather/deposit speed | Normal | Fast |

*(Exact values to be tuned during prototyping)*

### Internal Power Drain

- Drone's internal power drains while active (moving, building)
- If internal power depletes and drone is not grid-connected: drone enters **low-power mode** (reduced speed, no building)
- Drone recharges internal power when idle near a powered structure
- Drone **never stops working entirely** — low-power mode is a penalty, not a dead stop

### Grid Connection Detection

Each tick:
1. Check if any powered `PowerNode` is within the drone's connection radius
2. If yes → `grid_connected = true`, stats use boosted tier, internal power recharges
3. If no → `grid_connected = false`, stats use internal tier, internal power drains

Connection radius is a separate (larger) value than build range — you don't need to be right next to a machine, just in the rough area of powered infrastructure.

## Drone Actions

### Physical (Proximity Required)

| Action | Description |
|---|---|
| Construct | Build a machine or conveyor segment at target location |
| Demolish | Remove a machine or conveyor |
| Gather | Pull items from a machine's output or storage |
| Deposit | Insert items into a machine's input or storage |
| Repair | (Future) Fix damaged or degraded machines |

### Remote (No Proximity Required)

| Action | Description |
|---|---|
| Configure machine | Set recipe, filter, priority |
| View machine stats | Inspect inventory, throughput, state |
| Plan layout | Sketch/place building blueprints (queued for construction) |
| Analysis overlay | View flow, bottlenecks, power network |
| Assign drone tasks | Queue up construction jobs for any drone |

---

## Task System

Drones operate via a **task queue**. When you assign a construction job (e.g., place a smelter at location X), the drone:

1. Pathfinds to needed resources (or the game's resource depot)
2. Picks up required materials
3. Pathfinds to construction site
4. Constructs the building
5. Returns or picks up next task

You don't manually drive the drone. You assign what needs to happen — the drone handles travel autonomously.

### Task Assignment via Stylus

- **Tap a location in Build mode**: Creates a construction job at that location → drone auto-routes to complete it
- **Tap a machine (Sketch mode)**: Assigns a gather/deposit task
- **Long press on drone**: Opens task queue radial menu

---

## Drone Inventory

Each drone has a finite inventory.

```
Drone
  id: UUID
  position: Vector2
  inventory: {item_id: count}
  inventory_capacity: int       # max total items
  task_queue: [Task]
  state: idle | traveling | working | blocked
```

Inventory must be managed:
- Drone can't carry unlimited materials to a build site
- Multiple trips may be required for large builds
- Later game: logistics conveyors/networks can auto-supply build sites

---

## Focus System

At any time, **one drone is focused**. The focused drone:

- Receives direct stylus task assignments
- Is highlighted on the map
- Has its task queue shown in the UI

Non-focused drones:
- Continue executing their current task queue
- Can be tapped to switch focus to them
- Appear as smaller indicators on the map

Switching focus is instant — tap any drone to focus it.

---

## Multiple Drones (Mid/Late Game)

Additional drones provide:

- **Telepresence** between factories — drone 1 at Factory A, drone 2 at Factory B, you switch focus between them
- **Parallel construction** — reduce build time for large expansions
- **Specialization** (optional) — e.g., one drone dedicated to logistics, one to construction

Unlocked via a tech/progression unlock (not purchased — built in-factory).

Maximum drone count is finite and progression-gated.

---

## Hazard Zones

Some areas of the map contain **hazards** that must be cleared before the drone can safely navigate or build there.

Rules:
- Hazards block drone pathfinding (drone routes around them)
- Hazards prevent machines in the zone from producing
- Hazards are cleared by dedicating a drone (or resource) to the clearance task
- **Drones cannot be destroyed.** Hazards are a progression/challenge gate, not a punishment mechanic.

Examples of hazard types (moddable):
- Terrain obstructions
- Environmental contamination
- Structural instability zones

---

## Drone vs. Factory Interaction Summary

```
                    ┌───────────────────────────┐
                    │         DRONE              │
                    │  carries items, executes   │
                    │  physical tasks            │
                    │  internal power always on  │
                    └──────────┬────────────────┘
                               │ must be in range for:
               ┌───────────────┼───────────────┐
               ▼               ▼               ▼
         Construct          Gather           Deposit
          building          items            items

  Near powered structure → Grid-Connected mode:
    - Faster movement
    - Larger build range
    - Faster construction
    - Internal power recharges

  Remote (no range needed):
    - Configure recipe
    - Set filters
    - View stats
    - Plan layout
    - Analysis overlay
```
