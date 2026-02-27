extends StaticBody3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Sound Node References
@onready var sound_locked = $locked_door
@onready var sound_unlock = $door_unlock
@onready var sound_open = $door_open
@onready var sound_close = $door_close

@export_group("Door Settings")
@export var key_resource_needed: ItemData 
@export var open_anim_name: String = "open_door"
@export var close_anim_name: String = "close_door"

var is_open: bool = false
var is_locked: bool = true

func interact():
	if not is_locked:
		toggle_door()
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		if player.current_held_item == key_resource_needed:
			unlock_door(player)
		else:
			# Play the "Locked" jiggle sound
			if sound_locked: sound_locked.play()
			print("Locked!")

func unlock_door(player):
	is_locked = false
	if sound_unlock: sound_unlock.play() # Play "Unlock" click sound
	
	Inventory.remove_item(key_resource_needed)
	player.clear_hand()
	
	# Wait a tiny bit for the unlock sound before opening
	await get_tree().create_timer(0.3).timeout
	toggle_door()

func toggle_door():
	if is_open:
		if anim_player.has_animation(close_anim_name):
			anim_player.play(close_anim_name)
			if sound_close: sound_close.play() # Play "Close" creak/thud
			is_open = false
	else:
		if anim_player.has_animation(open_anim_name):
			anim_player.play(open_anim_name)
			if sound_open: sound_open.play() # Play "Open" creak
			is_open = true
