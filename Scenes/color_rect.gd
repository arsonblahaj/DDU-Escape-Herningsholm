extends ColorRect

# Call this from your Player's RayCast logic
func set_highlight(is_interacting: bool):
	if is_interacting:
		color = Color.GREEN # Change color when looking at a clue
		scale = Vector2(1.5, 1.5) # Make it slightly bigger
	else:
		color = Color.WHITE
		scale = Vector2(1, 1)
