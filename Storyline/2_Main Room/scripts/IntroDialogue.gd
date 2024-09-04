extends VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	# Check if the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				print("Keteken")
				TransitionScreen.transition_between()
				await TransitionScreen.on_transition_finished
				get_tree().change_scene_to_file("res://Storyline/2_Main Room/main_room.tscn")

func _on_finished():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Storyline/2_Main Room/main_room.tscn")
