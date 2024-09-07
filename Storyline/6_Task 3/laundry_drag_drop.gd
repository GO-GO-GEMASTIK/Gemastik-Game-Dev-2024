extends Node2D

var dropped_items_count = 0
var highest_z_index = 0
@onready var finish = %Finish

var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")
var laundry_room = load("res://Storyline/Bagian_3/Laundry/laundry.tscn")

func increment_count():
	dropped_items_count += 1
	if dropped_items_count == 9:
		finish.play()
		GameStateManager.complete_task(3)
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		if GameStateManager.get_string_state("TBC"):
			get_tree().change_scene_to_packed(tbc)
		else:
			get_tree().change_scene_to_packed(laundry_room)


func get_new_highest_z_index():
	highest_z_index += 1
	return highest_z_index
