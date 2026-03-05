## GameCamera2D
##
## Handles camera pan and zoom for both desktop and mobile/stylus.
##
## Desktop:
##   Shift + Left drag   → pan
##   Shift + Right drag  → reserved (future: secondary context drag)
##   Scroll wheel        → zoom toward cursor
##
## Mobile / Touch / S Pen:
##   Two-finger pan      → pan  (InputEventPanGesture)
##   Pinch               → zoom (InputEventMagnifyGesture)

extends Camera2D

const ZOOM_MIN := 0.2
const ZOOM_MAX := 8.0
const ZOOM_STEP := 0.12 # per scroll tick

var _panning := false
var _pan_prev_mouse := Vector2.ZERO


func _ready() -> void:
	# Start at a readable zoom level.
	zoom = Vector2(1.0, 1.0)


func _input(event: InputEvent) -> void:
	var im := get_node_or_null("/root/InputManager")
	var shift: bool = (im.pan_modifier_held as bool) if im else Input.is_key_pressed(KEY_SHIFT)

	# ------------------------------------------------------------------
	# Desktop — Shift + Left mouse drag → pan
	# ------------------------------------------------------------------
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and shift:
				_panning = true
				_pan_prev_mouse = event.global_position
				get_viewport().set_input_as_handled()
			elif not event.pressed and _panning:
				_panning = false
				get_viewport().set_input_as_handled()

		# Scroll wheel → zoom toward cursor
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and not shift:
			_zoom_toward(ZOOM_STEP, event.position)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and not shift:
			_zoom_toward(-ZOOM_STEP, event.position)
			get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion:
		if _panning:
			var delta: Vector2 = (event as InputEventMouseMotion).global_position - _pan_prev_mouse
			_pan_prev_mouse = (event as InputEventMouseMotion).global_position
			# Divide by zoom so pan speed is consistent at any zoom level.
			global_position -= delta / zoom.x
			get_viewport().set_input_as_handled()

	# ------------------------------------------------------------------
	# Mobile / Touch — two-finger pan
	# ------------------------------------------------------------------
	elif event is InputEventPanGesture:
		# PanGesture delta is in screen pixels.
		global_position += event.delta / zoom.x
		get_viewport().set_input_as_handled()

	# ------------------------------------------------------------------
	# Mobile / Touch — pinch zoom
	# ------------------------------------------------------------------
	elif event is InputEventMagnifyGesture:
		_zoom_by_factor(event.factor, get_viewport_rect().size * 0.5)
		get_viewport().set_input_as_handled()


# ---------------------------------------------------------------------------
# Zoom helpers
# ---------------------------------------------------------------------------

## Adjust zoom by a linear [delta], anchored to [screen_pos].
func _zoom_toward(delta: float, screen_pos: Vector2) -> void:
	var old_z := zoom.x
	var new_z := clampf(old_z + delta * old_z, ZOOM_MIN, ZOOM_MAX)
	_apply_zoom(old_z, new_z, screen_pos)


## Adjust zoom by a multiplicative [factor], anchored to [screen_pos].
func _zoom_by_factor(factor: float, screen_pos: Vector2) -> void:
	var old_z := zoom.x
	var new_z := clampf(old_z * factor, ZOOM_MIN, ZOOM_MAX)
	_apply_zoom(old_z, new_z, screen_pos)


func _apply_zoom(old_z: float, new_z: float, screen_anchor: Vector2) -> void:
	if is_equal_approx(old_z, new_z):
		return
	# Convert screen anchor to world position before zoom change.
	var half_vp := get_viewport_rect().size * 0.5
	var world_anchor := global_position + (screen_anchor - half_vp) / old_z
	# Reposition so the world point stays under the anchor.
	global_position = world_anchor - (screen_anchor - half_vp) / new_z
	zoom = Vector2(new_z, new_z)
