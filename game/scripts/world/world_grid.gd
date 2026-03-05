## WorldGrid
##
## Draws an infinite grid over the world so camera movement is visually obvious.
## Lines are calculated each frame from the camera's visible rect, so the grid
## appears infinite without storing any geometry.
##
## Grid is a child of World (world-space), so line coordinates are in world units.

extends Node2D

const CELL_SIZE := 64.0
const LINE_COLOR := Color(1.0, 1.0, 1.0, 0.07)
const AXIS_COLOR := Color(1.0, 1.0, 1.0, 0.25) # origin axes
const SUBGRID_DIV := 4 # subdivisions per cell
const SUB_COLOR := Color(1.0, 1.0, 1.0, 0.03)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var camera := get_viewport().get_camera_2d()
	if not camera:
		return

	var vp_size := get_viewport_rect().size
	var cam_zoom := camera.zoom.x
	var cam_pos := camera.global_position

	# Visible rect in world coordinates.
	var half_w := vp_size.x * 0.5 / cam_zoom
	var half_h := vp_size.y * 0.5 / cam_zoom

	var left := cam_pos.x - half_w
	var right := cam_pos.x + half_w
	var top := cam_pos.y - half_h
	var bottom := cam_pos.y + half_h

	# Line width that stays 1 px regardless of zoom.
	var lw := 1.0 / cam_zoom

	# -- Sub-grid (only visible when zoomed in enough to avoid noise) --
	if cam_zoom >= 1.0:
		var sub_size := CELL_SIZE / SUBGRID_DIV
		var sub_sx := floorf(left / sub_size) * sub_size
		var sub_sy := floorf(top / sub_size) * sub_size

		var sx := sub_sx
		while sx <= right:
			if not _is_on_major(sx):
				draw_line(Vector2(sx, top), Vector2(sx, bottom), SUB_COLOR, lw)
			sx += sub_size

		var sy := sub_sy
		while sy <= bottom:
			if not _is_on_major(sy):
				draw_line(Vector2(left, sy), Vector2(right, sy), SUB_COLOR, lw)
			sy += sub_size

	# -- Major grid --
	var start_x := floorf(left / CELL_SIZE) * CELL_SIZE
	var start_y := floorf(top / CELL_SIZE) * CELL_SIZE

	var gx := start_x
	while gx <= right:
		var color := AXIS_COLOR if is_zero_approx(gx) else LINE_COLOR
		draw_line(Vector2(gx, top), Vector2(gx, bottom), color, lw)
		gx += CELL_SIZE

	var gy := start_y
	while gy <= bottom:
		var color := AXIS_COLOR if is_zero_approx(gy) else LINE_COLOR
		draw_line(Vector2(left, gy), Vector2(right, gy), color, lw)
		gy += CELL_SIZE


func _is_on_major(value: float) -> bool:
	return is_zero_approx(fmod(value, CELL_SIZE))
