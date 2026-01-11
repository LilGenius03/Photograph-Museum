extends Node3D
@export var description_text: String 
@export var image_texture: Texture2D

@onready var picture_mesh_Vertical: MeshInstance3D = $PictureMesh_Vertical
var player_in_range := false

func _ready():
	update_picture_texture_Vertical()

func update_picture_texture_Vertical():
	if image_texture == null:
		return

	if picture_mesh_Vertical == null:
		push_error("PictureMesh_Horizontal not found")
		return
	

	var material := picture_mesh_Vertical.get_surface_override_material(0)

	if material == null:
		var base_material := picture_mesh_Vertical.mesh.surface_get_material(0)

		if base_material:
			material = base_material.duplicate()
		else:
			material = StandardMaterial3D.new()

		picture_mesh_Vertical.set_surface_override_material(1, material)

	material.albedo_texture = image_texture



func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.current_inspect_target = self
		body.show_inspection_prompt()


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		body.current_inspect_target = null
		body.hide_inspection_prompt()
