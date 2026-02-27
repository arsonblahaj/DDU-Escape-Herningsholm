extends StaticBody3D

@export var door_path: NodePath = "../doow_wood3"
@export var is_miller_locker: bool = false

@onready var anim_player = $AnimationPlayer
@onready var external_label = $Label3D 
@onready var internal_note = $MeshInstance3D/Note # The Label3D inside

var is_open: bool = false

func _ready():
	await get_tree().process_frame
	var door = get_node_or_null(door_path)
	
	if is_miller_locker and door:
		external_label.text = str(door.miller_locker_id)
		# Digit 4 is index [3]
		internal_note.text = "Ω = " + str(door.correct_code[3])
	else:
		external_label.text = str(randi_range(100, 999))
		if internal_note: internal_note.hide()

# Now matches the Keypad "interact" style
func interact():
	if not is_open:
		anim_player.play("open_door")
	else:
		anim_player.play("close_door")
	is_open = !is_open
