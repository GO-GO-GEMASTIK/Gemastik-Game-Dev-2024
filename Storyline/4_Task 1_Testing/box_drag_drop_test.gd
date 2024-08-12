extends Node2D

var dropped_items_count = 0
var highest_z_index = 0
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

@onready var finish = %Finish

func increment_count():
	dropped_items_count += 1
	if dropped_items_count == 9:
		finish.play()
		await get_tree().create_timer(1.0).timeout
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(tbc)

func get_new_highest_z_index():
	highest_z_index += 1
	return highest_z_index
