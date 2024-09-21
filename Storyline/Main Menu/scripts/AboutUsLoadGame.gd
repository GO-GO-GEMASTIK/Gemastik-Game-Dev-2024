extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.

var load_game = false
var exit_game = false

func _input(event):
	if event.is_action("click"):
		if load_game:
			load_save()
		elif exit_game:
			get_tree().quit()


func _on_area_2d_mouse_entered():
	self.animation = "mouse"
	if name == "LoadGame":
		load_game = true
	if name == "Exit":
		exit_game = true

func _on_area_2d_mouse_exited():
	self.animation = "default"
	if name == "LoadGame":
		load_game = false
	if name == "Exit":
		exit_game = false

func load_save():
	var save_path = "user://savegame.tres"
	if FileAccess.file_exists(save_path):
		var save_data : SaveData = ResourceLoader.load(save_path)
		if save_data and save_data is SaveData:
			# Apply the loaded data
			GameStateManager.set_tasks(save_data.tasks)
			GameStateManager.set_characteristics(save_data.characteristics)
			GameStateManager.set_string_states(save_data.string_states)
			GameStateManager.update_pos_main(save_data.ucing_pos)
			# Load the scene
			var scene_path = save_data.current_scene_path
			if ResourceLoader.exists(scene_path):
				var loaded_scene = load(scene_path)
				TransitionScreen.transition_between()
				await TransitionScreen.on_transition_finished
				get_tree().change_scene_to_packed(loaded_scene)
				print("Game loaded successfully.")
			else:
				print("Scene file not found: %s" % scene_path)
		else:
			print("Failed to load save data or incorrect format.")
	else:
		print("No save file found.")
