extends AnimatedSprite2D

@export var finish_sound: AudioStreamPlayer2D

@onready var main_item = $"."
@onready var animation_player = $"../AnimationPlayer"

var group := "dragable"

var kamar = load("res://Storyline/16_Bagian4/kamar/kamar.tscn")
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		if _is_on_top():
			main_item.set_z_index(ZIndexManager.get_newest_trash_z_index())
			animation_player.play("main_item")
			finish_sound.play()
			GameStateManager.complete_task(5)
			await get_tree().create_timer(3.0).timeout
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			if GameStateManager.get_string_state("TBC"):
				get_tree().change_scene_to_packed(tbc)
			else:
				get_tree().change_scene_to_packed(kamar)


func _on_area_2d_mouse_entered():
	add_to_group(group + "hovered")


func _on_area_2d_mouse_exited():
	remove_from_group(group + "hovered")


func _is_on_top() -> bool:
	for dragable in get_tree().get_nodes_in_group(group + "hovered"):
		if dragable.z_index > z_index:
			return false
	
	return true
