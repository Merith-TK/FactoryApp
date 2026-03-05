## PenButton
##
## On-screen software button that fires the secondary action (equivalent to
## the S Pen barrel button or RMB). Placed in the UI layer so it is always
## visible regardless of camera position.
##
## Behaviour:
##   - Tap → emits InputManager.secondary_pressed at the button's screen centre.
##   - Toggles a "held" visual while finger/stylus is down.

extends Button

const LABEL_IDLE := "✦ Pen"
const LABEL_HELD := "● Pen"


func _ready() -> void:
	text = LABEL_IDLE
	toggle_mode = false # fire on press, not latch
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP

	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)


func _on_button_down() -> void:
	text = LABEL_HELD
	var im := get_node_or_null("/root/InputManager")
	if im:
		var centre := get_screen_position() + size * 0.5
		(im as Node).emit_signal("secondary_pressed", centre)


func _on_button_up() -> void:
	text = LABEL_IDLE
	var im := get_node_or_null("/root/InputManager")
	if im:
		var centre := get_screen_position() + size * 0.5
		(im as Node).emit_signal("secondary_released", centre)
