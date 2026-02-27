extends CanvasLayer

@onready var grid = $PanelContainer/GridContainer
var slot_scene = preload("res://Scenes/Slot.tscn") 

var active_index: int = -1
var current_held_item_data: ItemData = null # Add this to track the ACTUAL item

func _ready():
	Inventory.inventory_changed.connect(refresh_ui)
	refresh_ui()

func _unhandled_input(event):
	if event.is_action_pressed("ui_inventory"):
		visible = !visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if visible else Input.MOUSE_MODE_CAPTURED

	# Hotbar keys
	if event.is_action_pressed("hotbar_1"): trigger_slot(0)
	elif event.is_action_pressed("hotbar_2"): trigger_slot(1)
	elif event.is_action_pressed("hotbar_3"): trigger_slot(2)
	elif event.is_action_pressed("hotbar_4"): trigger_slot(3)
	elif event.is_action_pressed("hotbar_5"): trigger_slot(4)

func trigger_slot(index: int):
	var slots = grid.get_children()
	var player = get_tree().get_first_node_in_group("player")
	
	if index >= slots.size(): return

	# If we click the same slot OR an empty slot: Deselect
	if index == active_index or slots[index].stored_item == null:
		deselect_all()
	else:
		# Select new item
		active_index = index
		current_held_item_data = slots[index].stored_item
		slots[index]._on_pressed()

	update_highlights()

func deselect_all():
	active_index = -1
	current_held_item_data = null
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.clear_hand()
	update_highlights()


# Inside your CanvasLayer script (the one with trigger_slot)
func update_highlights():
	var slots = grid.get_children()
	for i in range(slots.size()):
		if slots[i].has_method("set_highlight"):
			var is_active = (i == active_index)
			
			# Pass the color of the item if it exists, otherwise pass white
			var highlight_color = Color.WHITE
			if slots[i].stored_item:
				highlight_color = slots[i].stored_item.item_color
			
				slots[i].set_highlight(is_active, highlight_color)

func refresh_ui():
	# 1. Clear slots
	for child in grid.get_children():
		child.queue_free()
	
	await get_tree().process_frame 
	
	# 2. Rebuild slots and try to find where our held item moved to
	var found_item_at = -1
	for i in range(Inventory.items.size()):
		var item = Inventory.items[i]
		var new_slot = slot_scene.instantiate()
		grid.add_child(new_slot)
		new_slot.set_item(item)
		
		# If this slot has the item we were holding, track its new position
		if current_held_item_data != null and item == current_held_item_data:
			found_item_at = i

	# 3. Sync the index to the item's new home
	active_index = found_item_at
	
	# 4. If the item is gone from inventory entirely, stop holding it
	if active_index == -1 and current_held_item_data != null:
		deselect_all()
	
	update_highlights()
