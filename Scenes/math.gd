extends Label3D

@export var door_node: NodePath = "../../../doow_wood3"
@export var chalk_font: Font
@export var is_note_b: bool = false # Check this box for the second note

func _ready():
	if chalk_font: set("font", chalk_font)
	
	# Wait for the door to generate the random code
	await get_tree().process_frame
	
	var door = get_node_or_null(door_node)
	if door and door.correct_code.size() >= 2:
		var x_val = door.correct_code[0]
		var y_val = door.correct_code[1]
		
		if not is_note_b:
			# NOTE A: The standalone equation for X
			var result_a = x_val + 2
			text = "\nSolve for X:\n2 + X = " + str(result_a)
		else:
			# NOTE B: The dependency equation for Y
			# Logic: (X * 3) - Y = Result
			var result_b = (x_val * 3) - y_val
			text = "\nSolve for Y:\n(X * 3) - Y = " + str(result_b)
