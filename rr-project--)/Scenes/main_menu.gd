extends Node2D
@onready var button_sound: AudioStreamPlayer = $PostProcess/Style_Switch
@onready var post_processing := $PostProcess/CanvasLayer/ScreenFilter
@onready var Controls := $Controls
@onready var Main_menu := $Button_Manager/VBoxContainer
func _ready() -> void:
	pass # Replace with function body.

func _play_click():
	button_sound.play()

func _on_start_pressed() -> void:
	_play_click()
	_trigger_flash_and_change_scene()


func _on_style_switch_pressed() -> void:
	_play_click()
	post_processing.cycle_style()



func _on_quit_pressed() -> void:
	_play_click()
	get_tree().quit()
	
func _trigger_flash_and_change_scene():
	var flash = $"../Flash"
	flash.visible = true
	flash.modulate = Color.WHITE
	flash.modulate.a = 0.0

	var tween = get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 2.0, 0.5) #fade out
	tween.tween_property(flash, "modulate:a", 1.0, 0.2) #fade in
	await tween.finished
	get_tree().call_deferred("change_scene_to_file","res://Scenes/the_museum.tscn" )


func _on_controls_pressed() -> void:
	Controls.visible = true
	Main_menu.visible = false


func _on_return_pressed() -> void:
	Controls.visible = false
	Main_menu.visible = true
