extends Node2D

signal following
signal r_in
signal r_out

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera

var hutan := false
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")
# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======

# Called when the node enters the scene tree for the first time.
func _ready():
	following.emit()
	camera.set_limit(SIDE_RIGHT, GameStateManager.get_room_right_limit("bukit"))
	camera.set_limit(SIDE_BOTTOM, 2698)

func _input(event):
	if event.is_action_pressed("talk"):
		if hutan:
			GameStateManager.set_string_state("TBC", true)
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(tbc)


func _on_next_area_body_entered(body):
	if body == ucing:
		hutan = true
		r_in.emit()

func _on_next_area_body_exited(body):
	if body == ucing:
		hutan = false
		r_out.emit()


func _on_hutan_area_body_entered(body):
	pass # Replace with function body.
