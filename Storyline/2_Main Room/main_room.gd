extends Node2D

var style: DialogicStyle = load("res://Dialogue/speaker_textbox.tres")

var dialogue_is_running := false
var door_dialogue := false
var on_otan := false
var on_door := false

@onready var cari_pintu = $CanvasLayer/CariPintu

func _ready():
# PRELOAD TIMELINE TO REDUCE LAG
	style.prepare()
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "door_instruction_1":
		cari_pintu.set_visible(true)
	if argument == "enable_door":
		door_dialogue = true

#region DIALOGUE MANAGER
func _dialogue_start(body, dialogue: String):
	if body.name == "MC" and !dialogue_is_running:
		if dialogue == "papan_tulis":
			dialogue_starter(dialogue)
		if dialogue == "otan":
			on_otan = true
		elif dialogue == "wrong_door":
			on_door = true

func _dialogue_stop(body, dialogue: String):
	if body.name == "MC":
		if dialogue_is_running:
			dialogue_stopper()
		if dialogue == "otan":
			on_otan = false
		elif dialogue == "wrong_door":
			on_door = false

func _input(event):
	if !dialogue_is_running:
		if event.is_action_pressed("talk") and on_otan:
			dialogue_starter("otan")
		if event.is_action_pressed("talk") and on_door:
			if door_dialogue:
				dialogue_starter("wrong_door")
			else:
				dialogue_starter("unable_door")
#endregion ===========================


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
