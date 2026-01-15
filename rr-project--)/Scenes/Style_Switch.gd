extends ColorRect

@export var max_styles := 5
var current_style := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("style", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event.is_action_pressed("StyleSwitch"):
		current_style = (current_style + 1) % max_styles
		material.set_shader_parameter("style", current_style)
