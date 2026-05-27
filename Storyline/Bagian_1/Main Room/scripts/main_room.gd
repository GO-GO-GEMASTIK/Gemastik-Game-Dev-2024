extends Node2D

signal following
signal r_in
signal l_in
signal next

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera
@onready var otan = $Otan
@onready var right_limit = GameStateManager.get_room_right_limit("lantai_dasar")
@onready var guide_player = $CanvasLayer/GuidePlayer

@export var task_check: bool = GameStateManager.any_task_true()
@export var direction_kelas: bool = GameStateManager.get_string_state("DirectionKelas")
@export var direction_hutan: bool = GameStateManager.get_string_state("DirectionHutan")
@export var direction_laundry: bool = GameStateManager.get_string_state("DirectionLaundry")
@export var direction_kantin: bool = GameStateManager.get_string_state("DirectionKantin")
@export var is_bagian_2: bool = GameStateManager.get_string_state("Bagian2")
@export var is_bagian_3: bool = GameStateManager.get_string_state("Bagian3")
@export var is_bagian_4: bool = GameStateManager.get_string_state("Bagian4")

var style: DialogicStyle = load("res://Dialogue/speaker_textbox.tres")

var dialogue_is_running := false
var door_dialogue := false
var on_papan := false
var on_otan := false
var on_door := false
var talked_to_otan := GameStateManager.get_string_state("Talked2Otan")

# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======

func _ready():
# PRELOAD TIMELINE TO REDUCE LAG
	style.prepare()
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	camera.set_limit(SIDE_RIGHT, right_limit)
	camera.reset_smoothing()
	if is_bagian_2 or is_bagian_3 or is_bagian_4 or task_check:
		otan.set_visible(false)
		otan.set_monitoring(false)
	else:
		otan.set_visible(true)
		otan.set_monitoring(true)
	
	ucing.set_global_position(GameStateManager.get_pos_main())
	if GameStateManager.get_pos_state("TanggaMain"):
		ucing.set_global_position(Vector2(3700, 846))
		GameStateManager.set_pos_state("TanggaMain", false)
	if GameStateManager.get_pos_state("KeluarKelas"):
		#ucing.set_global_position(Vector2(3200, 846))
		GameStateManager.set_pos_state("KeluarKelas", false)
	if GameStateManager.get_pos_state("KeluarLaundry"):
		#ucing.set_global_position(Vector2(5555, 846))
		GameStateManager.set_pos_state("KeluarLaundry", false)
	if GameStateManager.get_pos_state("KeluarKantin"):
		#ucing.set_global_position(Vector2(6755, 846))
		GameStateManager.set_pos_state("KeluarKantin", false)
	
	if GameStateManager.get_string_state("GuidePintuKuning"):
		await get_tree().create_timer(1.0).timeout
		guide_player.play("show_guide_pintu")
	
	if direction_hutan:
		following.emit()
		r_in.emit()
	elif direction_kelas:
		await get_tree().create_timer(1.0).timeout
		guide_player.play("show_guide_kelas")
	elif direction_laundry:
		await get_tree().create_timer(1.0).timeout
		guide_player.play("show_laundry")
	elif direction_kantin:
		await get_tree().create_timer(1.0).timeout
		guide_player.play("show_kantin")

func _on_dialogic_signal(argument:String):
	if argument == "door_instruction_1":
		talked_to_otan = true
		GameStateManager.set_string_state("Talked2Otan", true)
		guide_player.play("show_guide_pintu")
		GameStateManager.set_string_state("GuidePintuKuning", true)
		GameStateManager.set_string_state("Bagian1", true)
	if argument == "enable_door":
		door_dialogue = true
	if argument == "jujur":
		GameStateManager.set_characteristic("Jujur", true)

func set_character_positions(save_data):
	# Set ucing's position if available
	if save_data.ucing_pos:
		if ucing:
			ucing.global_position = save_data.ucing_pos


#region DIALOGUE MANAGER
func _dialogue_start(body, dialogue: String):
	if body.name == "MC":
		if dialogue == "papan_tulis":
			on_papan = true
		if dialogue == "otan":
			on_otan = true
		elif dialogue == "wrong_door":
			on_door = true

func _dialogue_stop(body, dialogue: String):
	if body.name == "MC":
		dialogue_stopper()
		if dialogue == "otan":
			on_otan = false
		elif dialogue == "wrong_door":
			on_door = false
		elif dialogue == "papan_tulis":
			on_papan = false

func _input(event):
	if !dialogue_is_running:
		if event.is_action_pressed("talk") and on_otan:
			if !talked_to_otan:
				ucing.disable_movement()
				dialogue_starter("otan")
				await Dialogic.timeline_ended
				ucing.enable_movement()
			else:
				dialogue_starter("otan_reminding")
		if event.is_action_pressed("talk") and on_door:
			if door_dialogue:
				dialogue_starter("wrong_door")
			else:
				dialogue_starter("unable_door")
		if event.is_action_pressed("talk") and on_papan:
			dialogue_starter("papan_tulis")
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
