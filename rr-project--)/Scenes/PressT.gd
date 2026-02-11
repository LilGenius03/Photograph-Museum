extends Area3D
@export var Control_node : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		print("Interacted with Object")
		_trigger_flash_and_change_scene()

func _trigger_flash_and_change_scene():
	var flash = $"../FlashOverlay"
	flash.visible = true
	flash.modulate = Color.WHITE
	flash.modulate.a = 0.0

	var tween = get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 2.0, 0.5) #fade out
	tween.tween_property(flash, "modulate:a", 1.0, 0.2) #fade in
	
	await tween.finished
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/the_museum.tscn")


func _on_body_entered(body):
	if body.name == "Player":
		Control_node.visible = true
	


func _on_body_exited(body):
	if body.name == "Player":
		Control_node.visible = false
