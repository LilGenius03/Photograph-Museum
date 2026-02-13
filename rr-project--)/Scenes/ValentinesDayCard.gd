extends Area3D
@export var Card: Control
@export var PressF: Control
var ReadingCard = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ReadingCard = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Inspect") && ReadingCard == false:
		Card.visible = true
		ReadingCard = true
		PressF.visible = false
	elif Input.is_action_just_pressed("Inspect") && ReadingCard == true:
			Card.visible = false
			ReadingCard = false
			PressF.visible = true


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		PressF.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		PressF.visible = false
