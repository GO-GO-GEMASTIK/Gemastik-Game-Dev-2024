extends Area2D

@export var ucing: CharacterBody2D
@onready var icon_player= $AreaPapan/IconPlayer

var papan = load("res://Storyline/15_Kelas/papan.tscn")

var change_scene_papan = false

func _on_body_entered(body):
	if body.name == "MC":
		$PopSound.play()
		#icon_player.play("fade_in")
		#icon_player.queue("float_loop")


func _on_body_exited(body):
	pass
	#if body.name == "MC":
		#icon_player.play("fade_out")


func _input(event):
	if event.is_action_pressed("talk"):
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(papan)

