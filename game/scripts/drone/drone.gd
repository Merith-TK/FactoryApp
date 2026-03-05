## Drone
##
## The player's construction drone. For M0 this is a placeholder shape.
## Handles:
##  - Visual rendering (drawn procedurally, no sprite needed)
##  - Click-to-select (via Area2D input)
##  - Selection highlight
##
## Later milestones add: inventory, task queue, NavMesh movement, power modes.

extends Area2D

const RADIUS := 16.0
const BODY_COLOR := Color(0.4, 0.8, 1.0) # light blue body
const OUTLINE_COLOR := Color(1.0, 1.0, 1.0, 0.9)
const SELECT_COLOR := Color(1.0, 0.85, 0.2) # yellow selection ring
const DIR_COLOR := Color(1.0, 1.0, 1.0, 0.9) # direction arrow

var is_selected: bool = false


func _ready() -> void:
	# Connect to InputManager signals so selection is cleared when the
	# primary action fires somewhere other than this drone.
	var im := get_node_or_null("/root/InputManager")
	if im:
		im.primary_pressed.connect(_on_global_primary)

	input_pickable = true
	input_event.connect(_on_input_event)


func _draw() -> void:
	# Selection ring (drawn first, behind body).
	if is_selected:
		draw_circle(Vector2.ZERO, RADIUS + 5.0, SELECT_COLOR)

	# Body.
	draw_circle(Vector2.ZERO, RADIUS, BODY_COLOR)

	# Outline ring.
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, 32, OUTLINE_COLOR, 1.5, true)

	# Direction arrow — equilateral triangle pointing up (+Y is down in Godot,
	# so we point in -Y = visual "up").
	var tip := Vector2(0.0, - (RADIUS * 0.85))
	var base_l := Vector2(- (RADIUS * 0.45), (RADIUS * 0.4))
	var base_r := Vector2((RADIUS * 0.45), (RADIUS * 0.4))
	var arrow := PackedVector2Array([tip, base_l, base_r])
	draw_colored_polygon(arrow, DIR_COLOR)


func select() -> void:
	if is_selected:
		return
	is_selected = true
	queue_redraw()


func deselect() -> void:
	if not is_selected:
		return
	is_selected = false
	queue_redraw()


# ---------------------------------------------------------------------------
# Input
# ---------------------------------------------------------------------------

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			var im := get_node_or_null("/root/InputManager")
			if im and (im as Node).get("pan_modifier_held"):
				return # shift-click is camera pan, ignore
			select()
			get_viewport().set_input_as_handled()


func _on_global_primary(_pos: Vector2) -> void:
	# Deselect when user clicks anywhere else in the world.
	# The Area2D handler fires first (and calls set_input_as_handled),
	# so this only fires when the click missed us.
	deselect()
