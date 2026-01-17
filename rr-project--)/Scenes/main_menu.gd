extends Node2D
@onready var button_sound: AudioStreamPlayer = $PostProcess/Style_Switch
@onready var post_processing := $PostProcess

func _ready() -> void:
	pass # Replace with function body.

func _play_click():
	button_sound.play()

func _on_start_pressed() -> void:
	_play_click()
	get_tree().change_scene_to_file("res://Scenes/the_museum.tscn")


func _on_style_switch_pressed() -> void:
	_play_click()
	#post_processing.cycle_style()



func _on_quit_pressed() -> void:
	_play_click()
	get_tree().quit()
