## Drone
##
## The player's construction drone.
##
## Movement model:
##   The drone lerps toward the camera position so it is always "with" the
##   player. The direction arrow rotates to face the direction of travel.
##
## Interaction model:
##   Tap / click the drone → opens the action menu (issue tasks, check inventory)
##   NavigationAgent2D is used for autonomous task movement (go build, go fetch)
##   — not for player-driven movement.
##
## Later milestones add: inventory, task queue, power modes.

extends Area2D

const RADIUS := 16.0
const FOLLOW_SPEED := 8.0 # lerp weight — higher = snappier

const BODY_COLOR := Color(0.4, 0.8, 1.0)
const OUTLINE_COLOR := Color(1.0, 1.0, 1.0, 0.9)
const ACTIVE_COLOR := Color(1.0, 0.85, 0.2) # tapped / active ring
const DIR_COLOR := Color(1.0, 1.0, 1.0, 0.9)

## True while the action menu is open.
var is_active: bool = false

var _facing_angle: float = - PI * 0.5 # radians; default = facing up
var _prev_pos: Vector2 = Vector2.ZERO

@onready var _nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	var im := get_node_or_null("/root/InputManager")
	if im:
		im.primary_pressed.connect(_on_primary_pressed)
		print("[Drone] connected to InputManager.primary_pressed")
	else:
		print("[Drone] ERROR: InputManager not found!")

	_nav_agent.path_desired_distance = 4.0
	_nav_agent.target_desired_distance = 8.0
	_prev_pos = global_position
	print("[Drone] ready at ", global_position)


# ---------------------------------------------------------------------------
# Per-frame update
# ---------------------------------------------------------------------------

func _physics_process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d() as Camera2D
	if not camera:
		return

	# --- Camera follow ---
	var target := camera.global_position
	var new_pos := global_position.lerp(target, FOLLOW_SPEED * delta)

	var move_vec := new_pos - global_position
	if move_vec.length_squared() > 0.1:
		_facing_angle = move_vec.angle()
		queue_redraw()

	global_position = new_pos
	_prev_pos = new_pos

	# --- Autonomous task movement (future) ---
	if not _nav_agent.is_navigation_finished():
		var next := _nav_agent.get_next_path_position()
		var dir := next - global_position
		if dir.length_squared() > 1.0:
			global_position += dir.normalized() * minf(400.0 * delta, dir.length())
			_facing_angle = dir.angle()
			queue_redraw()


# ---------------------------------------------------------------------------
# Drawing
# ---------------------------------------------------------------------------

func _draw() -> void:
	# Active ring (behind body).
	if is_active:
		draw_circle(Vector2.ZERO, RADIUS + 5.0, ACTIVE_COLOR)

	# Body.
	draw_circle(Vector2.ZERO, RADIUS, BODY_COLOR)

	# Outline.
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, 32, OUTLINE_COLOR, 1.5, true)

	# Direction arrow — rotates to face movement direction.
	var rot := _facing_angle + PI * 0.5
	var tip := Vector2(0.0, - (RADIUS * 0.85)).rotated(rot)
	var base_l := Vector2(- (RADIUS * 0.45), (RADIUS * 0.4)).rotated(rot)
	var base_r := Vector2((RADIUS * 0.45), (RADIUS * 0.4)).rotated(rot)
	draw_colored_polygon(PackedVector2Array([tip, base_l, base_r]), DIR_COLOR)


# ---------------------------------------------------------------------------
# Input
# ---------------------------------------------------------------------------

func _on_primary_pressed(screen_pos: Vector2) -> void:
	var camera := get_viewport().get_camera_2d() as Camera2D
	if not camera:
		return

	var vp_size := get_viewport().get_visible_rect().size
	var world_pos := camera.global_position + (screen_pos - vp_size * 0.5) / camera.zoom.x
	var dist := world_pos.distance_to(global_position)
	print("[Drone] tap | world=", world_pos, " drone=", global_position, " dist=", dist)

	if dist <= RADIUS + 12.0:
		_toggle_menu()
	else:
		# Tap elsewhere closes the menu if open.
		if is_active:
			_close_menu()


func _toggle_menu() -> void:
	if is_active:
		_close_menu()
	else:
		_open_menu()


func _open_menu() -> void:
	is_active = true
	queue_redraw()
	print("[Drone] menu opened")
	# TODO M1: show task/inventory radial menu


func _close_menu() -> void:
	is_active = false
	queue_redraw()
	print("[Drone] menu closed")
