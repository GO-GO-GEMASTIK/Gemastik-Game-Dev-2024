extends AnimatedSprite2D


func _input(event):
	# Check if the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Check if the mouse click is inside the sprite's bounding box
			if self.animation == "mouse":
				# Transition to the next scene when the sprite is clicked
				var save_path = "user://savegame.tres"
				GameStateManager.reset_game_state()
				if FileAccess.file_exists(save_path):
					DirAccess.remove_absolute(save_path)
				get_tree().change_scene_to_file("res://Storyline/Bagian_1/Main Room/subscenes/intro_dialogue.tscn")


func _on_area_2d_mouse_entered():
	self.animation = "mouse"

func _on_area_2d_mouse_exited():
	self.animation = "default"

