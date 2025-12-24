extends Node3D
@export var description_text: String = "The most beautiful photos I've seen."
@export var image_texture: Texture2D

var player_in_range := false
# Called when the node enters the scene tree for the first time.

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.current_inspect_target = self


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		body.current_inspect_target = null
