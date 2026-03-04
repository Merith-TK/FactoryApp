# UX Design

## Design Philosophy

> The game is a drafting table. The stylus is a pen. The screen is the blueprint.

- No toolbar rows
- No character to control
- No finger-sized tap targets
- Everything is accessible from stylus alone
- Radial/context menus replace traditional UI panels

---

## Modes

Three primary modes, toggled via stylus button or software button:

| Mode | Description |
|---|---|
| **Sketch** | Draw conveyors, erase, plan layout |
| **Build** | Tap to place buildings, rotate, snap |
| **Analysis** | Overlay showing flow, bottlenecks, power |

See [02-input-system.md](./02-input-system.md) for mode transition diagram.

---

## Sketch Mode

The default mode. The stylus is a drawing instrument.

| Stylus Action | Behavior |
|---|---|
| Drag | Draw conveyor path (bezier/polyline) |
| Release near port | Auto-snap to port and connect |
| Release in empty space | Freeform path, snaps to grid if enabled |
| Button held + drag | Erase conveyor segments |
| Hover | Preview path ghost |

Conveyor lines:
- Drawn as splines
- Auto-resolve to straight segments on release (or stays curved — TBD)
- Snap to connected ports when endpoint is within snap radius

---

## Build Mode

Tap to place machines. Placement preview shown as ghost while hovering.

| Stylus Action | Behavior |
|---|---|
| Hover | Ghost preview of selected machine |
| Tap | Place machine at position |
| Hold button + tilt/rotate gesture | Rotate machine |
| Long press on placed machine | Open context radial menu |

### Machine Placement

- Machines have defined **input ports** (multiple) and **output port** (one, Satisfactory-style)
- Port faces are visually indicated with arrows/icons
- Rotation is freeform (OR snapped to 15° / 45° / 90° increments based on snap settings)

### Rotation

- Default: freeform
- Hold pen button → shows rotation handle
- Drag handle to rotate
- With snap enabled: snaps to configured increment

---

## Analysis Overlay Mode

Activated by holding pen button (or double tap). Non-destructive — no editing.

Overlays:
- **Flow rates** on conveyor segments (items/sec)
- **Bottlenecks** highlighted in red
- **Idle machines** highlighted in yellow
- **Power network** color-coded by load
- **Satisfaction** (input starvation vs output overflow)

Dismiss by releasing button or tapping anywhere.

---

## Grid Snap Settings

Grid is a **helper, not the backbone.**

Toggle states:
| Setting | Behavior |
|---|---|
| Off | Pure freeform placement and drawing |
| Position snap | Buildings snap to grid intersections |
| Rotation snap | Rotation locks to increment (default 45°) |
| Full snap | Both position and rotation |

Snap is a persistent toggle accessible from a minimal settings panel or radial menu.

---

## Conveyor Preview & Auto-Snap

1. As user draws, a ghost path follows the stylus
2. When stylus approaches a machine port within snap radius:
   - Path endpoint snaps to port
   - Port direction validated (output → input only, using dot product check)
3. On lift:
   - If both ends connected: conveyor created and linked
   - If one end free: conveyor created as open segment
   - If no valid path: preview dismissed

---

## Radial / Context Menu

Long press on any placed object opens a radial menu:

For machines:
- Delete
- Rotate
- Inspect (opens info panel with stats)
- Disconnect all

For conveyor segments:
- Delete segment
- Split
- Properties (speed, filter — if modded)

Radial menu is minimal, large enough for stylus tap.

---

## Camera / Navigation

| Action | Control |
|---|---|
| Pan | Two-finger drag OR middle mouse |
| Zoom | Pinch OR scroll wheel |
| Center on selection | Double-tap empty map |
| Fit all | TBD (gesture or button) |

No mini-map for MVP. May be added later.

---

## UI Panels (Minimal)

- **Mode indicator** — small corner badge showing current mode (Sketch / Build / Analysis)
- **Selected machine picker** — scrollable strip at bottom (Build mode only), shows available machines
- **Snap toggle** — icon button in corner
- **Software pen button** — visible only when no stylus detected or user enabled it

No HUD beyond the above.
