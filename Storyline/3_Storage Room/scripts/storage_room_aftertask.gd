extends Node2D

var dialogue_is_running = false
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

@onready var ucing = $MC

# Called when the node enters the scene tree for the first time.
func _ready():
	if !dialogue_is_running:
		dialogue_is_running = true
		ucing.disable_movement()
		Dialogic.start("box_selesai")
		await Dialogic.timeline_ended
		dialogue_is_running = false
		ucing.enable_movement()



func _on_buba_body_entered(body):
	if body.name == "MC" and !dialogue_is_running:
		Dialogic.start("gudang_buba")
		await Dialogic.timeline_ended
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(tbc)
