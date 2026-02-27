extends Button

var stored_item: ItemData

func set_item(data: ItemData):
	stored_item = data
	if data:
		icon = data.icon
		tooltip_text = data.item_name
	else:
		icon = null


func set_highlight(is_active: bool, color: Color = Color.WHITE):
	if is_active:
		self_modulate = color 
	else:
		self_modulate = Color(1, 1, 1)

func _on_pressed():
	if stored_item:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.hold_item(stored_item)
