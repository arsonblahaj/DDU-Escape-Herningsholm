extends StaticBody3D

@onready var key_item = $"../Key"
var is_moved: bool = false

func _ready():
	if key_item:
		key_item.hide()
		key_item.process_mode = PROCESS_MODE_DISABLED 

func interact():
	if is_moved: return
	
	is_moved = true
	
	# Create the tween
	var tween = create_tween().set_parallel(true)
	
	# 1. Rotate it to lay flat
	tween.tween_property(self, "rotation_degrees:x", 85, 0.4)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	
	# 2. Shift it forward (the 'kick' momentum)
	tween.tween_property(self, "position:z", position.z + 0.8, 0.11)
	
	# 3. Drop it downwards (Adjust the -0.2 depending on your model's height)
	# This ensures it lays flush with the floor mesh
	tween.tween_property(self, "position:y", position.y - 0.5, 0.7)\
		.set_trans(Tween.TRANS_SINE)
	
	# Reveal the key after the impact
	await tween.finished
	if key_item:
		key_item.show()
		key_item.process_mode = PROCESS_MODE_INHERIT
