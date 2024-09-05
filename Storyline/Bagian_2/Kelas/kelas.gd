extends Node2D

signal go_to_papan

#Loading & Preloading
@onready var task_2 = load("res://Storyline/5_Task 2/math_class.tscn")
var style: DialogicStyle = load("res://Dialogue/speaker_textbox.tres")

#OnReady
@onready var ucing = $MC
@onready var camera = ucing.camera
@onready var is_kelas: bool = GameStateManager.get_string_state("Kelas")
@onready var task_completed: bool = GameStateManager.is_task_completed(2)
@onready var animation = %AnimationPlayer
@onready var warning_task = %WarningTask
@onready var papan_skor = $CanvasLayer/PapanSkor

#Variables
var right_limit: int = GameStateManager.get_room_right_limit("kelas")
var duduk := false
var dialog_running := false
var view_score := false

# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======


# Called when the node enters the scene tree for the first time.
func _ready():
# === SETUP ===
	camera.set_limit(SIDE_RIGHT, right_limit)
# PRELOAD TIMELINE TO REDUCE LAG
	style.prepare()
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	Dialogic.signal_event.connect(_on_dialogic_signal)
# Storyline
	if task_completed:
		part_3()
	elif not is_kelas or debug:
		part_1()

# DIALOGIC SIGNALS
func _on_dialogic_signal(argument:String):
	if argument == "pan_to_ucing":
		camera.set_position(Vector2.ZERO)
	if argument == "kerja_sama":
		GameStateManager.set_characteristic("KerjaSama", true)


func _input(event):
	if event.is_action_pressed("talk"):
		if duduk:
			animation.play("hide_view_icon")
			duduk = false
			part_2()
		if view_score:
			papan_skor.recheck_and_update_visibility()
			papan_skor.set_visible(true)


#region TIMELINES
func part_1():
	ucing.disable_movement()
	
	#Dialogic.start("dialog_perkenalan")
	Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	ucing.enable_movement()
	animation.play("show_warning")

func part_2():
	ucing.disable_movement()
	ucing.look_right()
	ucing.set_global_position(Vector2(1500, 800))
	await get_tree().create_timer(1).timeout
	#camera.set_position(Vector2(1300, 0))
	
	#Dialogic.start("dialog_kelas")
	Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	warning_task.set_visible(true)
# === TASK2 HERE ===
func part_3():
	ucing.disable_movement()
	ucing.look_right()
	ucing.set_global_position(Vector2(1500, 800))
	await get_tree().create_timer(1).timeout
	
	#Dialogic.start("dialog_sifat")
	Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	TransitionScreen.transition_loading()
	await TransitionScreen.on_transition_finished
	
	#Dialogic.start("dialog_kelas_after_2")
	Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	ucing.enable_movement()
	
	go_to_papan.emit()
#endregion

#region SIGNAL MANAGEMENT
func _on_area_bangku_body_entered(body):
	if body == ucing and !task_completed:
		duduk = true
		animation.play("hide_warning")
		animation.queue("show_view_icon")
		animation.queue("float_view_icon")
	
func _on_area_bangku_body_exited(body):
	if body == ucing and !task_completed:
		duduk = false
		animation.play("show_warning")
		animation.queue("hide_view_icon")
	
func _on_area_papan_body_entered(body):
	if body == ucing and task_completed:
		view_score = true
		animation.play("show_papan")
		animation.queue("float_papan")

func _on_area_papan_body_exited(body):
	if body == ucing and task_completed:
		view_score = false
		animation.play("hide_papan")

func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_2)
#endregion


