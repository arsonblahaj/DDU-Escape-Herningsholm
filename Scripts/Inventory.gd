extends Node

# This is the "shout" the UI listens for
signal inventory_changed

# This array will now hold your 'ItemData' Resources (which have the icons)
var items = []

func add_item(item_data: ItemData):
	items.append(item_data)
	# This tells the 2D UI: "Hey! Refresh the screen now!"
	inventory_changed.emit()

func has_item(item_data: ItemData):
	return items.has(item_data)

func remove_item(item_data: ItemData):
	if items.has(item_data):
		items.erase(item_data)
		# Tell the UI an item is gone so it removes the icon
		inventory_changed.emit()
	else:
		print("Attempted to remove item not in inventory")

func use_item(item_data: ItemData):
	if items.has(item_data):
		items.erase(item_data)
		inventory_changed.emit()
		return true
	return false
