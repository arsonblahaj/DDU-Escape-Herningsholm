extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENS = 0.003

@onready var head = $Head
@onready var cam = $Head/Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENS)
		cam.rotate_x(-event.relative.y * SENS)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		if OS.get_keycode_string(keycode) == "Escape":
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED 
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
