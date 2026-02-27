extends Node3D

@export var door_path: NodePath = "../doow_wood3"

@onready var hour_hand = $Hour
@onready var minute_hand = $Min

# Based on your results:
# The Minute hand worked with 0 offset.
# The Hour hand was 180 degrees (6 hours) off from the goal.
var hour_offset: float = 180.0 
var minute_offset: float = 0.0

func _ready():
	await get_tree().process_frame
	
	var door = get_node_or_null(door_path)
	if door and door.correct_code.size() >= 3:
		var sigma = door.correct_code[2] 
		
		# H - M = Sigma logic
		var m_val = randi_range(1, 5)
		var h_val = sigma + m_val
		
		if h_val > 12:
			h_val = 12
			m_val = h_val - sigma
		
		# ROTATION LOGIC:
		# Use -30 for clockwise. 
		# We apply unique offsets to each hand to sync them.
		hour_hand.rotation_degrees.y = (h_val * -30.0) + hour_offset
		minute_hand.rotation_degrees.y = (m_val * -30.0) + minute_offset
		
		print("Clock Debug | H:", h_val, " M:", m_val, " Target:", sigma)
	else:
		print("Error: Door not found")
