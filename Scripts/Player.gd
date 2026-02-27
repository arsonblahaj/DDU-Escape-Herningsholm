extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENS = 0.003

@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var interaction_cast = %ShapeCast3D
@onready var hand = $Head/Camera3D/Hand

@onready var footstep_player = $Footstep
@export var step_distance: float = 3.5 
var step_timer: float = 0.0
var current_held_item: ItemData = null 

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENS)
		cam.rotate_x(-event.relative.y * SENS)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	handle_interaction()
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED 
		velocity.z = direction.z * SPEED
		if is_on_floor():
			var horizontal_vel = Vector2(velocity.x, velocity.z)
			step_timer += horizontal_vel.length() * delta
			if step_timer > step_distance:
				play_footstep()
				step_timer = 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		step_timer = 0.0
	move_and_slide()

func play_footstep():
	if footstep_player:
		footstep_player.pitch_scale = randf_range(0.9, 1.1)
		footstep_player.play()

# --- UPDATED ITEM LOGIC ---
func hold_item(item_data: ItemData):
	current_held_item = item_data 
	
	for child in hand.get_children():
		child.queue_free()
	
	if item_data.mesh_to_spa != null:
		var model = item_data.mesh_to_spa.instantiate()
		hand.add_child(model)
		model.position = Vector3.ZERO
		
		# --- TINT THE HELD MODEL ---
		var mesh = model if model is MeshInstance3D else model.find_child("*", true, false)
		if mesh:
			var mat = mesh.get_active_material(0)
			if mat:
				var unique_mat = mat.duplicate()
				unique_mat.albedo_color = item_data.item_color
				mesh.set_surface_override_material(0, unique_mat)

func clear_hand():
	current_held_item = null 
	for child in hand.get_children():
		child.queue_free()

func handle_interaction():
	var label = $CanvasLayer/BoxContainer/Label
	label.hide()
	if interaction_cast.is_colliding():
		var target = interaction_cast.get_collider(0)
		if target:
			var interactable = find_interactable(target)
			if interactable:
				label.show()
				if Input.is_action_just_pressed("interact"):
					interactable.interact()

func find_interactable(node):
	var current = node
	for i in range(3):
		if current == null: break
		if current.has_method("interact"):
			return current
		current = current.get_parent()
	return null
