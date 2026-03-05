# Base Content Catalog

## Machine Tiers

Five core machine types form the base production chain. Each tier is unlocked via the HUB milestone tech tree. **Ore deposits exist on the map from the start — you simply cannot process them until the appropriate machine is unlocked.**

---

## Machines

### Miner
**Tier unlock:** HUB Tier 1 (starting machine)

Placed on or adjacent to a resource deposit. Extracts raw ore and outputs it onto a conveyor.

```json
{
  "id": "miner",
  "display_name": "Miner",
  "input_ports": [],
  "output_ports": [{ "local_position": [1, 0], "direction": [1, 0] }],
  "power_consumption": 5,
  "recipes": ["mine_iron_ore", "mine_copper_ore", "mine_coal", "..."]
}
```

- No input required (draws from deposit beneath it)
- Output rate determined by recipe + power availability
- Must be placed within range of a deposit node to be active

---

### Shelter *(working name)*
**Tier unlock:** HUB Tier 1

Processes raw ores into ingots using heat/smelting. Single input, single output.

> **Note:** "Shelter" is the current working name. May be renamed (Smelter, Forge, Furnace, etc.) — TBD during art/naming pass.

```json
{
  "id": "shelter",
  "display_name": "Shelter",
  "input_ports": [{ "local_position": [-1, 0], "direction": [-1, 0] }],
  "output_ports": [{ "local_position": [1, 0], "direction": [1, 0] }],
  "power_consumption": 10,
  "recipes": ["smelt_iron", "smelt_copper", "smelt_tin", "..."]
}
```

**Example recipes:**

| Input | Output | Ticks |
|---|---|---|
| 1× iron ore | 1× iron ingot | 20 |
| 1× copper ore | 1× copper ingot | 20 |
| 2× quartz | 1× glass | 30 |

---

### Constructor
**Tier unlock:** HUB Tier 2

Takes ingots, produces basic manufactured materials. Single input, single output.

```json
{
  "id": "constructor",
  "display_name": "Constructor",
  "input_ports": [{ "local_position": [-1, 0], "direction": [-1, 0] }],
  "output_ports": [{ "local_position": [1, 0], "direction": [1, 0] }],
  "power_consumption": 15,
  "recipes": ["make_iron_plate", "make_copper_wire", "make_iron_rod", "..."]
}
```

**Example recipes:**

| Input | Output | Ticks |
|---|---|---|
| 1× iron ingot | 2× iron plate | 25 |
| 1× copper ingot | 4× copper wire | 20 |
| 1× iron ingot | 1× iron rod | 15 |

---

### Assembler
**Tier unlock:** HUB Tier 3

Combines multiple basic materials into advanced components. Multiple inputs (2+), single output.

```json
{
  "id": "assembler",
  "display_name": "Assembler",
  "input_ports": [
    { "local_position": [-1, -0.5], "direction": [-1, 0] },
    { "local_position": [-1,  0.5], "direction": [-1, 0] }
  ],
  "output_ports": [{ "local_position": [1, 0], "direction": [1, 0] }],
  "power_consumption": 25,
  "recipes": ["make_motor", "make_circuit_board", "make_frame", "..."]
}
```

**Example recipes:**

| Inputs | Output | Ticks |
|---|---|---|
| 2× iron rod + 2× copper wire | 1× motor | 40 |
| 2× copper wire + 1× glass | 1× circuit board | 35 |
| 4× iron plate + 2× iron rod | 1× reinforced frame | 50 |

---

### Factory
**Tier unlock:** HUB Tier 4–5

Combines advanced components into experimental/end-game materials. Multiple inputs, single output. Highest power draw.

```json
{
  "id": "factory",
  "display_name": "Factory",
  "input_ports": [
    { "local_position": [-1, -1], "direction": [-1, 0] },
    { "local_position": [-1,  0], "direction": [-1, 0] },
    { "local_position": [-1,  1], "direction": [-1, 0] }
  ],
  "output_ports": [{ "local_position": [1, 0], "direction": [1, 0] }],
  "power_consumption": 60,
  "recipes": ["make_computer", "make_drive", "make_reactor_component", "..."]
}
```

**Example recipes:**

| Inputs | Output | Ticks |
|---|---|---|
| 2× circuit board + 1× motor + 1× frame | 1× computer | 80 |
| 3× computer + 2× motor | 1× AI controller | 120 |

---

## Production Chain Overview

```
[Deposit]
   ↓  Miner          (Tier 1)
[Raw Ore]
   ↓  Shelter        (Tier 1)
[Ingots]
   ↓  Constructor    (Tier 2)
[Basic Materials]    iron plate, copper wire, iron rod, etc.
   ↓  Assembler      (Tier 3)
[Advanced Materials] motor, circuit board, reinforced frame, etc.
   ↓  Factory        (Tier 4-5)
[Experimental]       computer, AI controller, reactor parts, etc.
```

---

## Tech Lock Rule

> Ore deposits are placed on the map at world generation and visible from the start.  
> **You cannot process an ore until the machine for that tier is unlocked via the HUB.**

This means early game: you can *see* copper deposits but can't do anything with them until the Shelter is unlocked. Late ores (exotic types) may require Tier 3–4 unlocks before any processing machine accepts them.

---

## Base Items (Starter Set)

### Raw Resources (always present, harvested by Miner)
- Iron Ore
- Copper Ore
- Coal *(power fuel as well as craft input)*
- *(More added by later tiers: Tin Ore, Quartz, Oil, ...)*

### Ingots (produced by Shelter)
- Iron Ingot
- Copper Ingot
- Glass *(from Quartz)*

### Basic Materials (produced by Constructor)
- Iron Plate
- Iron Rod
- Copper Wire

### Advanced Materials (produced by Assembler)
- Motor
- Circuit Board
- Reinforced Frame

### Experimental Materials (produced by Factory)
- Computer
- *(Rest TBD during tech tree design)*

---

## Power Machines (Required for all of the above)

### Coal Generator
**Tier unlock:** HUB Tier 1

Consumes Coal, produces power.

```json
{
  "id": "coal_generator",
  "display_name": "Coal Generator",
  "input_ports": [{ "local_position": [-1, 0], "direction": [-1, 0] }],
  "output_ports": [],
  "power_production": 50,
  "recipes": ["burn_coal"]
}
```

*(Additional generator types unlocked in later tiers)*

---

## Naming Note

All machine and item names above are **working names** for the prototype. A naming/art pass will be done once gameplay is proven. "Shelter" in particular may change.
