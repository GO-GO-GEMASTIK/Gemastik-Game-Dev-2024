extends Area2D

var change_scene = false
var gudang = load("res://Storyline/3_Storage Room/storage_room.tscn")

func _on_body_entered(body):
	if body.name == "MC":
		$AnimationPlayer.play("fade_in")
		$PopSound.play()
		$BoxWarning.set_visible(false)
		Dialogic.start("scary")
		change_scene = true

func _on_body_exited(body):
	if body.name == "MC":
		$AnimationPlayer.play("fade_out")
		$BoxWarning.set_visible(false)
		change_scene = false

func _input(event):
	if change_scene and event.is_action_pressed("talk"):
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(gudang)
			
