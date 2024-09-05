extends Area2D

signal r_in
signal r_out

@onready var pintu = %IconPlayer

var door = false
var upstairs = load("res://Storyline/2_Main Room/main_room_upper.tscn")
var direction_kelas = false
var direction_hutan = false

func _process(delta):
	direction_kelas = GameStateManager.get_string_state("DirectionKelas")
	direction_hutan = GameStateManager.get_string_state("DirectionHutan")

func _on_body_entered(body):
	pintu.play("fade_in")
	pintu.queue("float_loop")
	door = true
	if direction_hutan or direction_kelas:
		r_out.emit()

func _on_body_exited(body):
	pintu.play("fade_out")
	door = false
	if direction_hutan or direction_kelas:
		r_in.emit()


func _input(event):
	if event.is_action_pressed("talk") and door:
		GameStateManager.set_pos_state("KeluarKamar", true)
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(upstairs)
