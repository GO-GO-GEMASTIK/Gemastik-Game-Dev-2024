extends Area2D

@onready var guide_player = %GuidePlayer
@onready var is_bagian_1 = GameStateManager.get_string_state("Bagian1")

var change_scene = false
var gudang = load("res://Storyline/Bagian_1/Storage Room/storage_room.tscn")
var masuk_gudang = false
var dia_running = false

func _on_body_entered(body):
	if body.name == "MC":
		$AnimationPlayer.play("fade_in")
		$PopSound.play()
		change_scene = true
		if is_bagian_1:
			if GameStateManager.get_string_state("GuidePintuKuning"):
				guide_player.play("hide_guide_pintu")
			if !dia_running:
				dia_running = true
				Dialogic.start("scary")
				await Dialogic.timeline_ended
				masuk_gudang = true
				dia_running = false



func _on_body_exited(body):
	Dialogic.end_timeline()
	if body.name == "MC":
		$AnimationPlayer.play("fade_out")
		change_scene = false
		masuk_gudang = false

func _input(event):
	if event.is_action_pressed("talk"):
		if change_scene:
			if masuk_gudang:
				GameStateManager.set_string_state("GuidePintuKuning", false)
				TransitionScreen.transition_between()
				await TransitionScreen.on_transition_finished
				get_tree().change_scene_to_packed(gudang)
			else:
				if !dia_running:
					dia_running = true
					Dialogic.start("unable_door")
					await Dialogic.timeline_ended
					dia_running = false
