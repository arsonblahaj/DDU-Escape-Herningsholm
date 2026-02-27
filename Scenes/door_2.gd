extends StaticBody3D

@export var code_length: int = 4
var correct_code: Array[int] = []
var current_input: Array[int] = []
var miller_locker_id: int = 0 # Added this for the locker/roster logic

@export var is_locked: bool = true
@onready var anim_player = $AnimationPlayer 
@onready var audio_player = $door_open 
@onready var wrong_audio = $door_unlock

func _ready():
	randomize_sequence()
	print("Door Script Initialized. Searching for buttons...")
	connect_buttons_recursive(self)

func randomize_sequence():
	correct_code.clear()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Generate code (ensure it matches your keypad button IDs)
	for i in range(code_length):
		correct_code.append(rng.randi_range(1, 4)) # Adjusted to 1-4 per your note
	
	# Generate the random Miller Locker ID here
	miller_locker_id = rng.randi_range(100, 200)
	
	print("!!! NEW SEQUENCE: ", correct_code, " | MILLER LOCKER: ", miller_locker_id, " !!!")

func connect_buttons_recursive(node: Node):
	for child in node.get_children():
		if child.has_signal("button_pressed"):
			child.button_pressed.connect(_on_button_pressed)
		connect_buttons_recursive(child)

func _on_button_pressed(id):
	if not is_locked: return 

	current_input.append(id)
	if current_input.size() == code_length:
		if current_input == correct_code:
			unlock_and_open()
		else:
			fail_sequence()

func fail_sequence():
	current_input.clear()
	if wrong_audio: wrong_audio.play()
	flash_all_buttons(get_tree().root) # Search globally for buttons to flash

func flash_all_buttons(node: Node):
	for child in node.get_children():
		if child.has_method("flash_red"):
			child.flash_red()
		flash_all_buttons(child)

func unlock_and_open():
	is_locked = false
	if audio_player: audio_player.play()
	if anim_player:
		anim_player.play("open_door") # Use your specific animation name
