extends Area2D

@export var ucing = CharacterBody2D
@export var icon_player: AnimationPlayer

var class_room = load("res://Storyline/17_Bagian_3/classroom_bagian_3.tscn")

var change_scene_upper = false
var change_scene_lower = false
var change_scene_main = false

func _on_body_entered(body):
	if body.name == "MC":
		$PopSound.play()
		icon_player.play("fade_in")
		icon_player.queue("float_loop")


func _on_body_exited(body):
	if body.name == "MC":
		icon_player.play("fade_out")


func _input(event):
	if event.is_action_pressed("talk"):
		#GameStateManager.update_pos_main(ucing.global_position)
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(class_room)

