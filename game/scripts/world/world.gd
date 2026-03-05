## World
##
## Owns the NavigationRegion2D for the entire walkable world space.
## For M0 (Type B pre-gen world) this is a single large flat rectangle.
## Hazard zones are added as NavigationObstacle2D children at world-gen time.
##
## The nav polygon is built in code to avoid encoding baked polygon data
## in .tscn files.

extends Node2D

## Half-size of the walkable area in world units.
## 8192 × 8192 total — enough for any M0 prototype world.
const NAV_HALF: float = 8192.0

var nav_region: NavigationRegion2D


func _ready() -> void:
	_build_nav_region()


func _build_nav_region() -> void:
	nav_region = NavigationRegion2D.new()
	nav_region.name = "NavRegion"
	add_child(nav_region)

	var poly := NavigationPolygon.new()

	# Directly assign vertices and a quad polygon — avoids the deprecated
	# make_polygons_from_outlines() which was removed in Godot 4.3.
	poly.vertices = PackedVector2Array([
		Vector2(-NAV_HALF, -NAV_HALF), # 0 top-left
		Vector2(NAV_HALF, -NAV_HALF), # 1 top-right
		Vector2(NAV_HALF, NAV_HALF), # 2 bottom-right
		Vector2(-NAV_HALF, NAV_HALF), # 3 bottom-left
	])
	poly.add_polygon(PackedInt32Array([0, 1, 2, 3]))

	nav_region.navigation_polygon = poly
	# Bake on the next physics frame so NavigationServer2D has time to register
	# the region before any agent queries the map.
	call_deferred("_bake_nav")


func _bake_nav() -> void:
	print("[World] baking nav polygon...")
	nav_region.bake_navigation_polygon()
	print("[World] nav bake done. region RID valid: ", nav_region.get_rid().is_valid())
