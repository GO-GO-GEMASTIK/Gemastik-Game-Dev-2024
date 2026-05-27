extends Area2D

signal r_in
signal r_out

@onready var pintu = %IconPlayer
@onready var guide_player = %GuidePlayer
@onready var pop = %Pop
@onready var open_door = %OpenDoor

var door = false
var upstairs = load("res://Storyline/Bagian_1/Main Room/main_room_upper.tscn")
var direction_kelas = false
var direction_hutan = false

func _process(delta):
	direction_kelas = GameStateManager.get_string_state("DirectionKelas")
	direction_hutan = GameStateManager.get_string_state("DirectionHutan")

func _on_body_entered(body):
	if direction_hutan or direction_kelas:
		pintu.play("fade_in")
		pintu.queue("float_loop")
		pop.play()
		door = true
		if direction_hutan:
			r_out.emit()

func _on_body_exited(body):
	if direction_hutan or direction_kelas:
		pintu.play("fade_out")
		door = false
		if direction_hutan:
			r_in.emit()


func _input(event):
	if event.is_action_pressed("talk") and door:
		open_door.play()
		if GameStateManager.get_string_state("DirectionKelas"):
			guide_player.play("hide_to_class")
		if GameStateManager.get_string_state("DirectionHutan"):
			guide_player.play("hide_hutan")
		GameStateManager.set_pos_state("KeluarKamar", true)
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(upstairs)
