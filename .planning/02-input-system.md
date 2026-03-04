# Input System

## Overview

The game is designed to be fully operable with a stylus. Input must support:

1. S Pen button detection (Samsung devices with Bluetooth S Pen)
2. Stylus button via standard Android input events (broad compatibility)
3. Software toggle button fallback (non-stylus devices and accessibility)

---

## Input Layers

### Layer 1 — Godot InputEvent (Primary)

Godot receives stylus input automatically on Android. The S Pen side button is exposed as `MOUSE_BUTTON_RIGHT` in the button mask of touch/drag events.

```gdscript
func _input(event):
    if event is InputEventScreenDrag:
        var pen_button_held = event.button_mask & MOUSE_BUTTON_MASK_RIGHT
```

This works on:
- Samsung S Pen (USB/tethered, no Bluetooth required)
- Any stylus that sends button state via Android input

### Layer 2 — Samsung S Pen Remote SDK (Advanced, Deferred)

For devices with **Bluetooth S Pen** (Air actions, remote gestures):
- Requires Android Studio plugin + Java/Kotlin wrapper
- Exposed to Godot via GDExtension or Android plugin
- Adds: gesture events, multi-button support, remote hover

**Status: Deferred. Not needed for initial prototype.**

### Layer 3 — Software Toggle (Fallback)

- A persistent on-screen button (minimal size, corner position)
- Toggles between Sketch mode and Build mode
- For devices without a stylus or without a stylus button

---

## Input Actions (Godot Action Map)

| Action | Trigger |
|---|---|
| `mode_toggle` | S Pen button tap OR software button |
| `erase_mode` | S Pen button held |
| `sketch_draw` | Stylus drag (no button) |
| `place_building` | Tap (Build mode) |
| `context_menu` | Long press |
| `analysis_overlay` | Double tap pen button OR hold software button |
| `zoom_in` / `zoom_out` | Pinch gesture (two-finger) OR scroll |
| `pan` | Two-finger drag OR middle mouse |

---

## Mode State Machine

```
           [ tap pen button ]
               ↓        ↑
  ┌─────────────────────────────────┐
  │         SKETCH MODE              │
  │  • draw conveyors                │
  │  • hold button = erase           │
  └─────────────────────────────────┘
               ↕ tap pen button
  ┌─────────────────────────────────┐
  │         BUILD MODE               │
  │  • tap = place building          │
  │  • ghost preview on hover        │
  │  • hold button = rotate          │
  └─────────────────────────────────┘
               ↕ hold pen button
  ┌─────────────────────────────────┐
  │        ANALYSIS OVERLAY          │
  │  • flow rates                    │
  │  • bottleneck highlights         │
  │  • power network                 │
  │  • idle machines                 │
  └─────────────────────────────────┘
```

---

## Stylus Data Available (Android + Godot)

| Property | Available |
|---|---|
| Position | Yes |
| Pressure | Yes (`event.pressure`) |
| Tilt | Yes (`event.tilt`) |
| Hover (above screen) | Yes on supported devices |
| Button state | Yes (primary = tip, secondary = side button) |

---

## Compatibility Matrix

| Device Type | S Pen Button | Software Fallback |
|---|---|---|
| Galaxy Tab with BT S Pen | Full (remote SDK, future) | Available |
| Galaxy Tab with USB S Pen | Via InputEvent | Available |
| Generic Android + stylus | Via InputEvent (if supported) | Available |
| Android touch only | Not available | Required |
