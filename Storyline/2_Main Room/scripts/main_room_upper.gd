extends Node2D

var dialogue_is_running := false
var on_door := false

@onready var guide_player = $CanvasLayer/GuidePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
# PRELOAD TIMELINE TO REDUCE LAG
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	if GameStateManager.get_string_state("GuidePintuKuning"):
		guide_player.play("show_guide_pintu")


func _input(event):
	if !dialogue_is_running:
		if event.is_action_pressed("talk") and on_door:
			dialogue_starter("locked_door")


#region PINTU IN/OUT
func _on_body_entered(body):
	if body.name == "MC" and !dialogue_is_running:
		on_door = true

func _on_body_exited(body):
	if body.name == "MC":
		if dialogue_is_running:
			dialogue_stopper()
		on_door = false
#endregion ==================


#region DIALOGUE DRIVER
func dialogue_starter(dialogue: String):
	dialogue_is_running = true
	Dialogic.start(dialogue)
	await Dialogic.timeline_ended
	dialogue_is_running = false

func dialogue_stopper():
	Dialogic.end_timeline()
	dialogue_is_running = false
#endregion ===========================
