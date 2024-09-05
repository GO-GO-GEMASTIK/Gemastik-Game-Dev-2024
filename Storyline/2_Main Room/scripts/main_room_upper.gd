extends Node2D

signal following
signal l_in

@onready var ucing = $MC
@onready var camera = ucing.camera
@onready var guide_player = $CanvasLayer/GuidePlayer
@onready var icon_to_main = $GuideIcon/IconToMain

@onready var right_limit = GameStateManager.get_room_right_limit("lantai_atas")
@onready var on_kamar = GameStateManager.get_pos_state("KeluarKamar")
@onready var direction_kelas = GameStateManager.get_string_state("DirectionKelas")
@onready var direction_hutan = GameStateManager.get_string_state("DirectionHutan")

var dialogue_is_running := false
var on_door := false

func _ready():
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	camera.set_limit(SIDE_RIGHT, right_limit)
	
	if on_kamar:
		ucing.set_global_position(Vector2(5810, 830))
		GameStateManager.set_pos_state("KeluarKamar", false)
	
	if direction_hutan or direction_kelas:
		l_in.emit()
	if GameStateManager.get_string_state("DirectionHutan"):
		following.emit()
	if GameStateManager.get_string_state("GuidePintuKuning"):
		guide_player.play("show_guide_pintu")
	if GameStateManager.get_string_state("Bagian3"):
		guide_player.play("show_guide_kelas")


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
