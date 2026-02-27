extends StaticBody3D

signal button_pressed(id)

@export var button_id: int = 1 
@export var button_color: Color = Color.WHITE

func _ready():
	# Finds the mesh even if it's nested inside the DAE scene
	var mesh = find_mesh(self)
	if mesh:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = button_color
		# Use material_override to ensure it forces the color over the DAE textures
		mesh.material_override = mat

# The function your Player script calls
func interact():
	button_pressed.emit(button_id)
	
	# "Click" animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.8, 0.8, 0.8), 0.05)
	tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.05)
	
	print("Button ", button_id, " pressed!")

# Called by the Door script when the sequence is wrong
func flash_red():
	var mesh = find_mesh(self)
	if mesh:
		var tween = create_tween()
		# Flash to Red
		tween.tween_property(mesh, "material_override:albedo_color", Color.RED, 0.1)
		# Shake side to side
		tween.tween_property(self, "position:x", 0.02, 0.05).as_relative()
		tween.tween_property(self, "position:x", -0.04, 0.05).as_relative()
		tween.tween_property(self, "position:x", 0.02, 0.05).as_relative()
		# Return to original color
		tween.tween_property(mesh, "material_override:albedo_color", button_color, 0.2)

# Helper to find the mesh regardless of DAE hierarchy
func find_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_mesh(child)
		if result:
			return result
	return null
