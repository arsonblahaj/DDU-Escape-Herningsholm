extends Area3D

@export var item_resource: ItemData # Drag your key_item.tres here!

func _input(event):
	if event.is_action_pressed("interact"): # Set "E" in Input Map
		if overlaps_body(get_tree().get_first_node_in_group("player")):
			Inventory.add_item(item_resource) # Uses your script!
			queue_free() # Delete the 3D model
