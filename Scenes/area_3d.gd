extends Area3D

@export var win_ui: CanvasLayer # Drag your CanvasLayer here in the inspector

func _ready():
	# Connect the signal if you haven't done it in the editor
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	# Check if the node entering is the player
	# (Adjust "Player" to match your player node's name or group)
	if body.name == "Player" or body.is_in_group("player"):
		show_win_screen()

func show_win_screen():
	win_ui.visible = true
	# Release the mouse so the player can click the restart button
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
