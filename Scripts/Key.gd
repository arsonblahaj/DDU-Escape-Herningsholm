extends StaticBody3D

@export var item_info: ItemData 

func _ready():
	# Wait for the scene to fully load so we can see the 'Old Key' children
	await get_tree().process_frame
	
	if item_info:
		apply_world_tint()

func apply_world_tint():
	# Find the mesh inside the "Old Key" sub-scene
	var mesh = find_mesh(self)
	
	if mesh:
		# Get the material already on the model (preserves textures)
		var mat = mesh.get_active_material(0)
		if mat:
			var unique_mat = mat.duplicate()
			# Apply the tint from the ItemData
			unique_mat.albedo_color = item_info.item_color
			mesh.set_surface_override_material(0, unique_mat)
			print("World Key tinted to: ", item_info.item_color)
	else:
		print("Could not find mesh to tint in world.")

# Helper function to find the MeshInstance3D inside the sub-scene
func find_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_mesh(child)
		if result:
			return result
	return null

func interact():
	if item_info:
		Inventory.add_item(item_info) 
		queue_free()
