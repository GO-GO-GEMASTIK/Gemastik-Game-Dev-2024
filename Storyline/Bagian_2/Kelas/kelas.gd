extends Node2D

signal go_to_papan

#Loading & Preloading
var style: DialogicStyle = load("res://Dialogue/speaker_textbox.tres")
@onready var task_2 = load("res://Storyline/5_Task 2/math_class.tscn")
@onready var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")
@onready var kamar = load("res://Storyline/16_Bagian4/Kamar/kamar.tscn")
@onready var main = load("res://Storyline/2_Main Room/main_room.tscn")

#OnReady
@onready var ucing = $MC
@onready var camera = ucing.camera
@onready var maung = $Maung
@onready var buba = $Buba
@onready var bu_cilla = $BuCilla

@onready var animation = %AnimationPlayer
@onready var warning_task = %WarningTask
@onready var papan_skor = $CanvasLayer/PapanSkor
@onready var list_pekerjaan = %ListPekerjaan

@onready var is_kelas: bool = GameStateManager.get_string_state("Kelas")
@onready var task_2_completed: bool = GameStateManager.is_task_completed(2)
@export var is_bagian_2: bool = GameStateManager.get_string_state("Bagian2")
@export var is_bagian_3: bool = GameStateManager.get_string_state("Bagian3")


#Variables
var right_limit: int = GameStateManager.get_room_right_limit("kelas")
var duduk := false
var dialog_running := false
var papan := false
var view_score := false
var ngobrol := false
var talked := false
var pengumuman := false
var view_task := false
var to_main := false

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
	if is_bagian_3:
		b3_part_1()
	if is_bagian_2:
		if task_2_completed:
			part_3()
		else:
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
			part_2()
			duduk = false
		if view_score:
			part_4()
			papan = false
			view_score = false
		if ngobrol:
			animation.play("hide_view_talk")
			b3_part_2()
			ngobrol = false
		if view_task:
			animation.play("hide_pengumuman")
			animation.queue("hide_papan")
			b3_part_3()
			view_task = false
			papan = false
		if to_main:
			animation.play("hide_door")
			animation.queue("hide_laundry")
			GameStateManager.set_pos_state("KeluarKelas", true)
			
			TransitionScreen.transition_loading()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(main)


#region TIMELINES
# === BAGIAN 2 ===
func part_1():
	ucing.disable_movement()
	
	Dialogic.start("dialog_perkenalan")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	ucing.enable_movement()
	animation.play("show_warning")

func part_2():
	ucing.disable_movement()
	ucing.look_right()
	ucing.set_global_position(Vector2(1500, 800))
	await get_tree().create_timer(1).timeout
	#camera.set_position(Vector2(1300, 0))
	
	Dialogic.start("dialog_kelas")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	warning_task.set_visible(true)
# === TASK2 HERE ===
func part_3():
	ucing.disable_movement()
	ucing.look_right()
	ucing.set_global_position(Vector2(1500, 800))
	await get_tree().create_timer(1).timeout
	
	Dialogic.start("dialog_sifat")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	TransitionScreen.transition_loading()
	await TransitionScreen.on_transition_finished
	
	Dialogic.start("dialog_kelas_after_2")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	ucing.enable_movement()
	papan = true
	
	go_to_papan.emit()
	
func part_4():
	ucing.disable_movement()
	papan_skor.recheck_and_update_visibility()
	papan_skor.set_visible(true)
	
	Dialogic.start("dialog_papan")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	papan_skor.set_visible(false)
	ucing.enable_movement()
	GameStateManager.set_string_state("Bagian2", false)
	GameStateManager.set_string_state("Bagian3", true)
	
	TransitionScreen.transition_loading()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(kamar)

# === BAGIAN 3 ===
func b3_part_1():
	bu_cilla.set_visible(false)
	maung.set_global_position(Vector2(1200, 830))
	buba.set_global_position(Vector2(1350, 817))
	maung.set_flip_h(true)
	buba.set_flip_h(true)

func b3_part_2():
	ucing.disable_movement()
	
	Dialogic.start("B3_dialog_kelas")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	talked = true
	go_to_papan.emit()
	
	papan = true
	pengumuman = true
	animation.play("show_pengumuman")
	ucing.enable_movement()
	
func b3_part_3():
	ucing.disable_movement()
	list_pekerjaan.set_visible(true)
	
	Dialogic.start("B3_mendapat_tugas")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	list_pekerjaan.set_visible(false)
	animation.queue("show_laundry")
	GameStateManager.set_string_state("DirectionLaundry", true)
	ucing.enable_movement()
#endregion

#region SIGNAL MANAGEMENT
func _on_area_bangku_body_entered(body):
	if body == ucing and !task_2_completed and is_bagian_2:
		duduk = true
		animation.play("hide_warning")
		animation.queue("show_view_icon")
		animation.queue("float_view_icon")
func _on_area_bangku_body_exited(body):
	if body == ucing and !task_2_completed and is_bagian_2:
		duduk = false
		animation.play("show_warning")
		animation.queue("hide_view_icon")
	
func _on_area_papan_body_entered(body):
	if body == ucing and papan:
		animation.play("show_papan")
		animation.queue("float_papan")
		if is_bagian_2:
			view_score = true
		elif pengumuman:
			view_task = true
			animation.queue("hide_pengumuman")
	
func _on_area_papan_body_exited(body):
	if body == ucing and papan:
		animation.play("hide_papan")
		if is_bagian_2:
			view_score = false
		elif pengumuman:
			view_task = false
			animation.queue("show_pengumuman")

func _on_area_ngobrol_body_entered(body):
	if body == ucing and is_bagian_3 and !talked:
		ngobrol = true
		animation.play("show_view_talk")
		animation.queue("float_view_talk")
func _on_area_ngobrol_body_exited(body):
	if body == ucing and is_bagian_3 and !talked:
		ngobrol = false
		animation.play("hide_view_talk")

func _on_area_pintu_body_entered(body):
	if body == ucing and GameStateManager.get_string_state("DirectionLaundry"):
		animation.play("show_door")
		animation.queue("float_door")
		to_main = true
func _on_area_pintu_body_exited(body):
	if body == ucing and GameStateManager.get_string_state("DirectionLaundry"):
		animation.play("hide_door")
		to_main = false

func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_2)
#endregion

