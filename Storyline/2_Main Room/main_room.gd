extends Node2D

signal following
signal r_in
signal l_in

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera
@onready var otan = $Otan
@onready var right_limit = GameStateManager.get_room_right_limit("lantai_dasar")
@onready var guide_player = $CanvasLayer/GuidePlayer

var style: DialogicStyle = load("res://Dialogue/speaker_textbox.tres")

var dialogue_is_running := false
var door_dialogue := false
var on_otan := false
var on_door := false

# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======

func _ready():
# PRELOAD TIMELINE TO REDUCE LAG
	style.prepare()
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	camera.set_limit(SIDE_RIGHT, right_limit)
	
	if GameStateManager.get_pos_state("TanggaMain"):
		ucing.set_global_position(Vector2(3700, 800))
		GameStateManager.set_pos_state("TanggaMain", false)
	
	if GameStateManager.get_string_state("GuidePintuKuning"):
		guide_player.play("show_guide_pintu")
	
	if GameStateManager.get_string_state("DirectionHutan"):
		otan.set_visible(false)
		following.emit()
		r_in.emit()
	
	if GameStateManager.get_string_state("Bagian3"):
		otan.set_visible(false)
		guide_player.play("show_guide_kelas")
		l_in.emit()

func _on_dialogic_signal(argument:String):
	if argument == "door_instruction_1":
		guide_player.play("show_guide_pintu")
		GameStateManager.set_string_state("GuidePintuKuning", true)
	if argument == "enable_door":
		door_dialogue = true
	if argument == "jujur":
		GameStateManager.set_characteristic("Jujur", true)


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


