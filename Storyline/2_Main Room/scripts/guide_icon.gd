extends Area2D

signal l2b
signal b2r
signal r2b
signal b2l
signal r_out
signal r_in
signal go_outside

@export var ucing: CharacterBody2D
@export var icon_export: AnimationPlayer
@onready var icon_player = $IconPlayer

var upper_room = load("res://Storyline/2_Main Room/main_room_upper.tscn")
var lower_room = load("res://Storyline/2_Main Room/main_room_lower.tscn")
var main_room = load("res://Storyline/2_Main Room/main_room.tscn")
var outside = preload("res://Storyline/16_Bagian4/BelakangSekolah/belakang_sekolah.tscn")

var change_scene_upper = false
var change_scene_lower = false
var change_scene_main = false
var change_scene_outside = false

func _on_body_entered(body):
	if body.name == "MC":
		$PopSound.play()
		icon_player.play("fade_in")
		icon_player.queue("float_loop")
		
		if name == "IconNaik":
			change_scene_upper = true
		elif name == "IconTurun":
			change_scene_lower = true
		elif name == "IconToMain":
			change_scene_main = true
			if global_position.x < ucing.global_position.x:
				l2b.emit()
			else:
				r2b.emit()
		elif name == "PintuKeluar":
			change_scene_outside = true
			r_out.emit()


func _on_body_exited(body):
	if body.name == "MC":
		icon_player.play("fade_out")
		
		if name == "IconNaik":
			change_scene_upper = false
		elif name == "IconTurun":
			change_scene_lower = false
		elif name == "IconToMain":
			change_scene_main = false
			if global_position.x < ucing.global_position.x:
				b2l.emit()
			else:
				b2r.emit()
		elif name == "PintuKeluar":
			change_scene_outside = false
			r_in.emit()


func _input(event):
	if event.is_action_pressed("talk"):
		if change_scene_upper:
			GameStateManager.update_pos_main(ucing.global_position)
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(upper_room)
		elif change_scene_lower:
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(lower_room)
		elif change_scene_main:
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(main_room)
		elif change_scene_outside:
			TransitionScreen.transition_loading()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(outside)

