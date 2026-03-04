# Gameplay Loop

## Core Loop (Session to Session)

```
Explore map
  → Find resource deposits
  → Build harvesters + connect conveyors
  → Process raw resources into components
  → Use components to build more machines
  → Extend power grid to new areas
  → Fulfill mission targets (production quotas)
  → Earn tech unlocks
  → Unlock better machines/drones
  → Explore further, bigger factory
  → Repeat
```

---

## Resources

### Deposits

- Raw resources exist at **fixed locations** on the map, determined by **world seed**
- Deposits are **infinite** — connect a harvester and it flows indefinitely
- Deposit locations are spread across the world, incentivizing expansion

### World Generation

- World is **seed-based procedural generation**
- Resource placement, hazard zones, and terrain are all seed-derived
- **Open question (deferred):** Whether world tiles are saved to disk, or only buildings/player state are saved and terrain is re-generated from seed on load. Both are valid — decide at save system implementation time.

### Harvesting

- Player places a **Harvester** machine on or adjacent to a resource deposit
- Harvester requires power to operate
- Harvester outputs raw resources onto an outbound conveyor
- No manual gathering required — purely automated once connected

---

## Production Chain

Resources flow through a chain of processing machines:

```
[Deposit]
   ↓ harvester
[Raw Resource]  (iron ore, copper ore, coal, etc.)
   ↓ smelter / processor
[Basic Component]  (iron ingot, copper ingot, etc.)
   ↓ assembler / fabricator
[Intermediate]  (iron plate, wire, circuit board, etc.)
   ↓ advanced assembler
[Advanced Component]  (motor, computer, etc.)
   ↓ ...
[Mission Target Item]
```

Complexity is **medium** — bottlenecks matter and throughput tuning is rewarding, but the game does not punish inefficiency harshly. You can always expand.

---

## Missions (Game-Driven)

Missions are **production targets** — the game asks you to produce a quantity of a specific item (or set of items).

- Completing a mission → earns **HUB points** (or equivalent currency) used to unlock the next tier of tech
- Missions are the primary driver of tech tree progression
- Early missions are simple (produce iron plates), later missions require complex chains (produce computers, motors, etc.)
- **Story integration is deferred** — narrative layer will be added later. Mechanically, missions are just production targets for now.

### Mission Structure

```
Mission
  id: String
  display_name: String
  description: String
  requirements: [{item_id, quantity}]
  reward: TechUnlock | HubPoints
  unlocks_next: [mission_id]
```

---

## Tech Tree

Two parallel tracks, inspired by Satisfactory's **HUB** (milestones) and **MAM** (optional research):

### Track 1 — HUB Milestones (Linear, Main Progression)

- Gated by mission completions
- Strictly linear tiers — complete all of tier N before tier N+1 unlocks
- Unlocks: new machine types, conveyor tiers, drone upgrades, new resource types
- The **entire main game is completable via this track alone**
- Roughly 5–7 tiers

Example HUB progression:
```
Tier 1: Basic smelting, basic conveyors, basic power
Tier 2: Multi-input assemblers, faster conveyors
Tier 3: Advanced processing, power grid upgrades
Tier 4: Automated logistics, second drone unlock
Tier 5: End-game components, final mission target
```

### Track 2 — Research Lab (Branching, Optional)

- Unlocked mid-game
- Player chooses research paths freely, no fixed order
- Costs resources (feed items into the Research Lab machine)
- Unlocks: quality-of-life machines, drone stat boosts, alternate recipes, efficiency upgrades, cosmetics
- **Does not block main mission progression** — purely additive

Example branches:
- **Logistics branch** — filter inserters, priority splitters, buffer chests
- **Drone branch** — increased carry capacity, faster recharge, additional drone slots
- **Power branch** — better generators, energy storage, wireless power (future)
- **Efficiency branch** — overclock modules, alternate recipes that trade one resource for another

---

## Progression Pacing

| Phase | What You're Doing |
|---|---|
| **Early** | Single drone, manual-ish construction, basic ore → ingot chains, learning the stylus controls |
| **Mid** | Multiple resource types, assembler chains, first power grid expansion, Research Lab unlocked |
| **Late** | Multi-drone operation, complex multi-stage production, optimizing bottlenecks, exotic resources |
| **Endgame** | Final HUB milestone production target, then full sandbox |

---

## Sandbox After Completion

After the final HUB milestone:
- All tech is accessible
- No more mandatory missions (optional challenge missions may be offered)
- Full creative freedom — build for scale, aesthetics, or optimization

---

## Deferred / TBD

- Narrative/story layer integrated into missions
- Challenge missions (post-endgame optional targets)
- World tile persistence vs seed-regeneration decision
- Exact tech tree item list and tier requirements
- Research Lab cost curves
