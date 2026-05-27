extends VideoStreamPlayer

@export var main: PackedScene = load("res://Storyline/Bagian_1/Main Room/main_room.tscn")


func _input(event):
	# Check if the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				TransitionScreen.transition_between()
				await TransitionScreen.on_transition_finished
				get_tree().change_scene_to_packed(main)

func _on_finished():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(main)
