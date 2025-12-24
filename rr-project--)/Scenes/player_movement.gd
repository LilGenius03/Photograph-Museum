extends CharacterBody3D
var inspecting := false
var current_inspect_target = null

const SENSITIVITY = 0.01
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0

#bob variables
const BOB_FREQ = 2
const BOB_AMP = 0.08
var t_bob = 0.0

#FOV Variable
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D
@export var inspect_ui: CanvasLayer
@export var inspect_label: Label

func enter_inspect_mode(target):
	inspecting = true

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	inspect_ui.visible = true
	inspect_label.text = target.description_text

func exit_inspect_mode():
	inspecting = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	inspect_ui.visible = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(inspect_label)
	print(inspect_ui)

func _unhandled_input(event):
	if inspecting:
		return

	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if inspecting:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Handle Sprint
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	#headbob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE *velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("Inspect"):
		if inspecting:
			exit_inspect_mode()
		elif current_inspect_target:
			enter_inspect_mode(current_inspect_target)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos
