# World Generation

## Two World Types (Performance Comparison)

Two world generation modes will be implemented and tested against each other for performance, storage, and feel. Selected at new game creation.

---

## Type A — Chunk-Based Exploration (Generate on Visit)

The world is infinite in theory. **Chunks are only generated when the drone or camera enters them** for the first time.

- World is divided into fixed-size chunks (e.g., 256×256 tiles)
- Unvisited chunks do not exist in memory or on disk
- When a new chunk enters view/range: generate it from seed + chunk coordinates
- Generated chunks are **saved to disk** and never re-generated (persistent terrain)
- Resource deposits, hazards, and terrain features are placed per-chunk from seed

**Pros:**
- No upfront generation cost
- Naturally rewards exploration
- Memory footprint stays small early game

**Cons:**
- Chunk boundary seams must be handled carefully (deposits don't split across chunks weirdly)
- Save data grows as exploration grows
- Slightly more complex generation code

---

## Type B — Full Pre-Generation (Seed → Entire World Upfront)

At new game creation, the **entire world is generated once** from the seed and held in memory / saved to disk.

- World has a fixed finite size (e.g., 4096×4096 tiles, or configurable)
- All resource deposits and hazards are placed at game start
- Player can see the full map scope immediately (fog-of-war optional)
- **Option:** terrain is never saved — only buildings/player state saved, terrain re-generated from seed on load (smaller save files)

**Pros:**
- Simpler chunk management (no streaming)
- Easier to reason about resource distribution
- "Terrain re-gen from seed" variant keeps save files very small

**Cons:**
- Upfront generation time at world creation (acceptable for a loading screen)
- Fixed world size (can't expand beyond initial bounds)
- Full map in memory may be a concern on low-end devices

---

## Decision Criteria

Both types will be prototyped. The winner is determined by:

| Criterion | Weight |
|---|---|
| Performance on mid-range Android tablet | High |
| Save file size at late game | Medium |
| Feel of exploration / discovery | Medium |
| Implementation complexity | Low |

**Working assumption:** Start with **Type B (pre-gen)** for the prototype since it's simpler to implement. Add Type A (chunk streaming) in Milestone 2 or as an alternate mode.

---

## World Data Structure

Regardless of type, world state is represented the same way:

```
WorldMetadata
  seed: int
  world_type: "chunk" | "pregen"
  size: Vector2i          # only relevant for pregen
  chunk_size: Vector2i    # only relevant for chunk mode

ResourceDeposit
  id: UUID
  position: Vector2
  resource_type: String   # e.g., "iron_ore"
  is_active: bool         # false if a hazard is blocking it

HazardZone
  id: UUID
  area: Rect2
  type: String
  cleared: bool
```

---

## Resource Distribution Guidelines

To be tuned during prototyping, but as a starting rule:

- **Basic ores** (iron, copper, coal) — common, within early exploration range
- **Mid-tier ores** (tin, quartz, oil) — moderate distance from start
- **Rare/advanced ores** — far from start, often near or behind hazard zones
- Start position always guaranteed to have at least one iron and one coal deposit within short range

---

## Fog of War (Optional / Deferred)

- Type B may optionally use a fog-of-war layer hiding unexplored areas
- Not required for prototype — full map visible by default
- Deferred decision
