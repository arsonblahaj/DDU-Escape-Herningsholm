extends Node3D

@export var door_path: NodePath = "../doow_wood3"

# Drag your hand meshes here
@onready var hour_hand = $Hour
@onready var minute_hand = $Min

func _ready():
	# Wait one frame to ensure the Door has generated the random code
	await get_tree().process_frame
	
	var door = get_node_or_null(door_path)
	if door and door.correct_code.size() >= 3:
		var sigma = door.correct_code[2] # This is the 3rd digit of the code
		
		# We need H - M = Sigma. 
		# Let's pick a random Minute value (1 to 5) to keep it varied.
		var m_val = randi_range(1, 4)
		var h_val = sigma + m_val
		
		# ROTATION LOGIC:
		# 360 degrees / 12 hours = 30 degrees per hour unit.
		# We use negative because Godot rotates counter-clockwise by default, 
		# but clocks rotate clockwise.
		hour_hand.rotation_degrees.y = h_val * -30
		minute_hand.rotation_degrees.y = m_val * -30
		
		print("Clock Clue: Hour ", h_val, " - Min ", m_val, " = ", sigma)
