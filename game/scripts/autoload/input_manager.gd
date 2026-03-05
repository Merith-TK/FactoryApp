## InputManager — Autoload singleton
##
## Owns the canonical input action definitions and exposes the current
## meta-key (Shift) state so any system can check it cheaply.
##
## Action map (registered at startup):
##   action_primary        — Left click / S Pen touch press
##   action_secondary      — Right click / S Pen barrel button
##   action_pan_modifier   — Shift key held
##
## Desktop shorthand:
##   Shift + LMB drag      → camera pan   (handled in GameCamera2D)
##   Shift + RMB           → reserved / future context action
##   LMB                   → action_primary  (pen press)
##   RMB                   → action_secondary (pen button)
##   Scroll wheel          → camera zoom  (handled in GameCamera2D)
##
## Mobile / S Pen:
##   Stylus touch          → action_primary
##   S Pen barrel button   → action_secondary (Godot maps it to MOUSE_BUTTON_RIGHT)
##   Two-finger pan        → camera pan   (InputEventPanGesture in GameCamera2D)
##   Pinch                 → camera zoom  (InputEventMagnifyGesture in GameCamera2D)

extends Node

# Emitted so other systems can respond without polling Input every frame.
signal primary_pressed(position: Vector2)
signal primary_released(position: Vector2)
signal secondary_pressed(position: Vector2)
signal secondary_released(position: Vector2)

## True while the pan modifier (Shift) is held.
var pan_modifier_held: bool = false


func _ready() -> void:
	_register_actions()


func _register_actions() -> void:
	_ensure_action("action_primary")
	_add_mouse_button("action_primary", MOUSE_BUTTON_LEFT)

	_ensure_action("action_secondary")
	_add_mouse_button("action_secondary", MOUSE_BUTTON_RIGHT)

	_ensure_action("action_pan_modifier")
	_add_key("action_pan_modifier", KEY_SHIFT)


func _input(event: InputEvent) -> void:
	# Track shift state for camera and other systems.
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT:
			pan_modifier_held = event.pressed

	# Emit convenience signals — only fire for non-pan-modifier clicks
	# so camera drag does not also trigger a primary action.
	if event is InputEventMouseButton:
		var pos: Vector2 = (event as InputEventMouseButton).position

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not pan_modifier_held:
				primary_pressed.emit(pos)
				get_viewport().set_input_as_handled()
			elif not event.pressed:
				primary_released.emit(pos)

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and not pan_modifier_held:
				secondary_pressed.emit(pos)
				get_viewport().set_input_as_handled()
			elif not event.pressed:
				secondary_released.emit(pos)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

func _ensure_action(action: StringName) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)


func _add_mouse_button(action: StringName, button: MouseButton) -> void:
	for existing in InputMap.action_get_events(action):
		if existing is InputEventMouseButton and existing.button_index == button:
			return # already registered
	var ev := InputEventMouseButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)


func _add_key(action: StringName, keycode: Key) -> void:
	for existing in InputMap.action_get_events(action):
		if existing is InputEventKey and existing.keycode == keycode:
			return
	var ev := InputEventKey.new()
	ev.keycode = keycode
	InputMap.action_add_event(action, ev)
