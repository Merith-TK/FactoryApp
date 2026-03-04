# Simulation Architecture

## Philosophy

The simulation is the game. It must be:

- **Deterministic** — same inputs always produce same outputs
- **Tick-based** — fixed rate (e.g. 10 ticks/sec), not frame-rate dependent
- **Pure data** — no frame-time or random-without-seed behavior
- **Isolated** — simulation core has no dependency on rendering or UI

This allows the same core to run locally or on a server without modification.

---

## Simulation Tick

- Fixed rate: **10 ticks per second** (adjustable, but fixed)
- Each tick: all machines pull from inputs, process, push to outputs
- No frame-delta math in simulation — only tick counters
- Visual interpolation between ticks is a rendering concern, not simulation

---

## Core Data Structures

### Machine

```
Machine
  id: UUID
  type: String          # references MachineDefinition
  position: Vector2
  rotation: float
  input_ports: [Port]
  output_ports: [Port]
  state: MachineState   # idle, running, starved, blocked
  progress: float       # 0.0 to 1.0 within current processing cycle
  inventory: {item_id: count}
```

### Port

```
Port
  id: UUID
  machine_id: UUID
  local_position: Vector2   # relative to machine origin
  direction: Vector2        # unit vector, rotated with machine
  port_type: input | output
  connected_conveyor: UUID | null
  filter: [item_id] | null  # optional item filter
```

### Conveyor

```
Conveyor
  id: UUID
  source_port: UUID    # must be an output port
  dest_port: UUID      # must be an input port
  capacity: float      # items per tick throughput cap
  path: [Vector2]      # world-space points (spline or grid-aligned)
  items: [ItemOnConveyor]
```

### ItemOnConveyor

```
ItemOnConveyor
  item_type: String
  path_progress: float   # 0.0 (source) to 1.0 (destination)
```

### Construction Drone

```
Drone
  id: UUID
  position: Vector2
  inventory: {item_id: count}
  inventory_capacity: int
  task_queue: [Task]
  state: idle | traveling | working | blocked
  focused: bool             # true for the one active drone
```

### Task

```
Task
  id: UUID
  type: construct | demolish | gather | deposit | clear_hazard
  target_position: Vector2
  target_id: UUID | null    # machine or conveyor being acted on
  required_items: {item_id: count}  # for construct tasks
```

### Hazard Zone

```
HazardZone
  id: UUID
  area: Rect2 | Polygon    # blocked region
  type: String             # moddable hazard type
  cleared: bool
  clear_cost: {item_id: count} | null
```

---

## Simulation Model — Physical Items (Confirmed)

Each item is a real entity that travels along a conveyor path.

Each tick:
1. Each item on a conveyor advances along its path by conveyor speed
2. If item reaches end of conveyor → attempt to enter destination machine's input buffer
3. If destination is full → item stops (conveyor backs up)
4. Machine pulls from input buffer, processes over N ticks, deposits to output buffer
5. Items in output buffer → enter outbound conveyor

This is visually clear and intuitive: you see items moving.

**Performance note:** This is heavier than throughput-graph simulation. Optimize with spatial bucketing or pooling if item counts become large. If performance degrades at scale, a hybrid (physical sim on visible conveyors, throughput for off-screen) can be introduced later.

---

## Machine Definition (Moddable)

All machine types loaded from JSON:

```json
{
  "id": "smelter",
  "display_name": "Smelter",
  "size": [2, 2],
  "input_ports": [
    { "local_position": [-1, 0], "direction": [-1, 0] }
  ],
  "output_ports": [
    { "local_position": [1, 0], "direction": [1, 0] }
  ],
  "recipes": ["smelt_iron"]
}
```

---

## Recipe Definition (Moddable)

```json
{
  "id": "smelt_iron",
  "inputs": { "iron_ore": 1 },
  "outputs": { "iron_ingot": 1 },
  "ticks": 20
}
```

A cycle of `ticks` ticks must pass with inputs available before output is produced.

---

## Power System (Core Mechanic)

Power is a first-class simulation system, not optional.

### Power Grid

- Generators produce power (in units/tick)
- Machines consume power (in units/tick)
- The grid is a separate graph: nodes = machines/generators, edges = power lines
- Per tick: sum all generation, subtract all consumption, broadcast state
- Machines without sufficient grid power: **stall** (go idle, no production)
- Power lines are drawn by the player in Sketch mode (same tool as conveyors, separate layer)

### Power Data Structures

```
PowerNode
  id: UUID
  machine_id: UUID     # machine or generator this node belongs to
  role: producer | consumer | both
  power_production: float   # units/tick (generators)
  power_consumption: float  # units/tick (machines)
  connected_lines: [UUID]

PowerLine
  id: UUID
  node_a: UUID
  node_b: UUID
  capacity: float      # max power transfer per tick
```

### Drone Power Interaction

See [08-player-drone.md](./08-player-drone.md) for full drone power rules.

In simulation terms:
- Drone has `internal_power: float` that drains each tick while active
- If drone is within range of a powered structure: `grid_connected: bool = true`
- Grid connection replenishes drone power and unlocks boosted stats
- Drone power state is evaluated each tick based on proximity to powered nodes

```
Drone
  ...existing fields...
  internal_power: float       # 0.0 to internal_power_max
  internal_power_max: float
  grid_connected: bool        # true if near a powered structure this tick
  power_mode: internal | grid # determines active stat tier
```

### Machine Definition — Power Fields

Added to machine JSON:
```json
{
  "id": "smelter",
  "power_consumption": 10,
  "power_node": { "role": "consumer" }
}
```

Generators:
```json
{
  "id": "coal_generator",
  "power_production": 50,
  "power_node": { "role": "producer" }
}
```

---

## Validation Rules

These are enforced at connection time (not during simulation):

- Output port → Input port only (no output-to-output)
- One conveyor per port (ports are single connection)
- No cycles allowed in item flow graph (TBD — may allow buffer loops)
- Item type filters on ports respected

---

## Analysis Data (Computed Per Tick)

For the Analysis overlay (see [03-ux-design.md](./03-ux-design.md)):

```
TickStats
  per_machine:
    throughput_in: float
    throughput_out: float
    state: running | idle | starved | blocked | unpowered
  per_conveyor:
    flow_rate: float       # items/sec
    utilization: float     # 0.0 to 1.0
  per_power_node:
    production: float
    consumption: float
    satisfied: bool        # false = brownout in this node's grid island
  drone:
    power_mode: internal | grid
    internal_power: float
    grid_connected: bool
```

---

## Godot Node Structure (Proposed)

```
World (Node2D)
  SimulationCore (Node)     ← pure logic, no rendering
    MachineManager
    ConveyorManager
    PowerManager
    DroneManager
    HazardManager
    TickClock
  WorldRenderer (Node2D)    ← reads from SimulationCore, draws
    MachineSprites
    ConveyorPaths
    PowerLineRenderer
    DroneSprites
    AnalysisOverlay
  InputHandler (Node)       ← processes stylus events, calls SimulationCore
```
