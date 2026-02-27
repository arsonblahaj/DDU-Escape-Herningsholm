extends Label3D

@export var door_path: NodePath = "../../doow_wood3"
@export var chalk_font: Font

func _ready():
	if chalk_font: set("font", chalk_font)
	
	# Wait two frames to be absolutely sure the Door script has finished its _ready()
	await get_tree().process_frame
	await get_tree().process_frame
	
	var door = get_node_or_null(door_path)
	
	# Safety Check: If door is null, show an error on the paper instead of crashing
	if door == null:
		text = "ERROR:\nCannot find Door Node.\nCheck door_path in Inspector."
		return

	# Start the list
	var roster_text = "CLASS 3-B ROSTER:\n"
	roster_text += "------------------\n"
	
	# Static deco names
	roster_text += "Adams, B. ...... 102\n"
	roster_text += "Beck, T. ....... 144\n"
	
	# THE GOAL: Miller (Pulls from the Door script)
	roster_text += "Miller, J. ..... " + str(door.miller_locker_id) + "\n"
	
	# More deco names with randomized numbers for immersion
	var students = ["Nolan, S.", "Reed, V.", "Smith, K.", "Young, L."]
	for student in students:
		var random_locker = randi_range(100, 200)
		# Ensure we don't accidentally display Miller's number for someone else
		if random_locker == door.miller_locker_id: 
			random_locker += 1
		roster_text += student + " ...... " + str(random_locker) + "\n"
	
	text = roster_text
