extends AnimatedSprite2D

@export var finish_sound: AudioStreamPlayer2D

var group := "dragable"

var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		if _is_on_top():
			finish_sound.play()
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(tbc)


func _on_area_2d_mouse_entered():
	add_to_group(group + "hovered")


func _on_area_2d_mouse_exited():
	remove_from_group(group + "hovered")


func _is_on_top() -> bool:
	for dragable in get_tree().get_nodes_in_group(group + "hovered"):
		if dragable.z_index > z_index:
			return false
	
	return true
