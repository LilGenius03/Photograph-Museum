extends Node3D

@export var description_text: String
@export var image_texture: Texture2D

@export var picture_height: float = 0.8
@export var frame_padding: float = 0.12

@onready var picture_mesh: MeshInstance3D = $Picture_Mesh
#@onready var frame_root: Node3D = $FrameRoot


func _ready():
	update_picture_frame()


func update_picture_frame():
	if image_texture == null:
		return

	# --- IMAGE ASPECT ---
	var img_w := float(image_texture.get_width())
	var img_h := float(image_texture.get_height())
	var aspect := img_w / img_h
	var picture_width := picture_height * aspect

	# --- DUPLICATE MESH (THIS IS THE KEY FIX) ---
	var base_mesh := picture_mesh.mesh
	if base_mesh == null:
		push_error("PictureMesh has no mesh")
		return

	var unique_mesh := base_mesh.duplicate()
	unique_mesh.resource_local_to_scene = true
	picture_mesh.mesh = unique_mesh

	var plane := unique_mesh as PlaneMesh
	if plane == null:
		push_error("PictureMesh must use PlaneMesh")
		return

	plane.size = Vector2(picture_width, picture_height)

	# --- UNIQUE MATERIAL ---
	var material := StandardMaterial3D.new()
	material.resource_local_to_scene = true
	material.albedo_texture = image_texture
	material.roughness = 1.0
	material.metallic = 0.0

	picture_mesh.set_surface_override_material(0, material)

	# --- FRAME RESIZE (NOW WORKS AGAIN) ---
	#frame_root.scale = Vector3(
		#picture_width + frame_padding,
		#picture_height + frame_padding,
		#1.0
	#)



func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.current_inspect_target = self
		body.show_inspection_prompt()


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		body.current_inspect_target = null
		body.hide_inspection_prompt()
