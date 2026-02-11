extends Node3D

@onready var state_machine = $AnimationTree["parameters/playback"]
@export var Control_Node: Control
func _ready():
	$AnimationTree.active = true
	state_machine.travel("Idle")
	$AnimationTree.animation_finished.connect(_on_animation_tree_animation_finished)

func _input(event):
	if event.is_action_pressed("take_photo"):
		state_machine.travel("Taking_photo")



func _trigger_flash_and_change_scene():
	var flash = $FlashOverlay
	flash.visible = true
	flash.modulate = Color.WHITE
	flash.modulate.a = 0.0

	var tween = get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 2.0, 0.5) #fade out
	tween.tween_property(flash, "modulate:a", 1.0, 0.2) #fade in
	
	await tween.finished
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/first_date.tscn")    


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Taking_photo":
		_trigger_flash_and_change_scene()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		Control_Node.visible = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		Control_Node.visible = false
