extends Node2D

var dialogue_is_running = false
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

@onready var ucing = $MC

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1.0).timeout
	if !dialogue_is_running:
		dialogue_is_running = true
		ucing.disable_movement()
		ucing.get_tree()
		
		Dialogic.start("box_selesai")
		await Dialogic.timeline_ended
		
		dialogue_is_running = false
		ucing.enable_movement()
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(tbc)

