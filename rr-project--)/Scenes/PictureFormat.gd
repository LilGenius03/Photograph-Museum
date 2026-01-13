extends Control

@onready var image_rect: TextureRect = $VBoxContainer/TextureRect
@onready var description_label: Label = $VBoxContainer/Label


func set_picture(texture: Texture2D, description: String) -> void:
	if texture == null:
		image_rect.texture = null
	else:
		image_rect.texture = texture

	description_label.text = description
