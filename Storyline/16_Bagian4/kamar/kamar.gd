extends Node2D

signal next
signal next_part
signal following
signal r_in

@export var cula_kamera := Texture2D

@onready var ucing = $MC
@onready var cula = $Cula
@onready var buba = $Buba
@onready var maung = $Maung

@onready var camera: Camera2D = ucing.camera
@onready var animations = $CanvasLayer/Control/Animations
@onready var night_ambience = $NightAmbience

@onready var guide_player = $CanvasLayer/GuidePlayer

@export var is_bagian_3: bool = GameStateManager.get_string_state("Bagian3")
@export var is_bagian_4: bool = GameStateManager.get_string_state("Bagian4")

var dialogue_is_running = false

# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======

# Called when the node enters the scene tree for the first time.
func _ready():
# SETUP
	camera.limit_right = GameStateManager.get_room_right_limit("kamar")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	ucing.look_left()
	
	if is_bagian_3:
		run_b3_part_1()
	elif is_bagian_4:
		if not GameStateManager.is_task_completed(5):
			ucing.disable_movement()
			run_b4_part_1()
		elif GameStateManager.is_task_completed(5):
			ucing.disable_movement()
			run_b4_part3()

func _on_dialogic_signal(argument:String):
	if argument == "cula_switch":
		cula.set_texture(cula_kamera)
	if argument == "buba_datang":
		camera.set_position(Vector2(1000,0))
	if argument == "buba_pindah":
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		camera.set_position(Vector2(0,0))
		buba.set_global_position(Vector2(745, 821))
		buba.set_flip_h(false)


#region ---STORYLINE---
# === BAGIAN 3 ===
func run_b3_part_1():
	maung.set_visible(false)
	buba.set_visible(false)
	cula.set_visible(false)
	dialog_runner("B3_monolog_kamar")
	await next
	guide_player.play("show_to_class")
	GameStateManager.set_string_state("DirectionKelas", true)

# === BAGIAN 4 ===
func run_b4_part_1():
	maung.set_visible(true)
	buba.set_visible(true)
	buba.set_flip_h(true)
	cula.set_visible(true)
	night_ambience.set_visible(true)
	await get_tree().create_timer(1.0).timeout
	dialog_runner("B4_1_kamar_malam")
	await next
	play_animation("night2day")
	await next
	night_ambience.set_visible(false)
	await get_tree().create_timer(1.0).timeout
	await next
	dialog_runner("B4_2_kamar_pagi")
	await next
	run_b4_part_2()
# ---
func run_b4_part_2():
	play_animation("day2night")
	await next
	cula.set_visible(false)
	buba.set_visible(false)
	await next
	dialog_runner("B4_3_kamar_malam_kedua")
	await next
	guide_player.play("show_guide")
# --task 5 here--
func run_b4_part3():
	maung.set_visible(true)
	buba.set_visible(true)
	cula.set_visible(false)
	buba.set_flip_h(true)
	buba.set_global_position(Vector2(2450, 805))
	ucing.set_global_position(Vector2(1080, 850))
	maung.set_global_position(Vector2(930, 835))
	await get_tree().create_timer(1.0).timeout
	dialog_runner("B4_4_orangtua_ucing_maung")
	await Dialogic.timeline_ended
	
	guide_player.play("show_hutan")
	
	await get_tree().create_timer(1.0).timeout
	GameStateManager.set_string_state("DirectionHutan", true)
	following.emit()
	r_in.emit()
#endregion


#region ---DRIVERS---
func play_animation(anim_name: String):
	transition()
	await next
	animations.set_visible(true)
	animations.play(anim_name)
	await animations.animation_finished
	TransitionScreen.transition_in()
	animations.set_visible(false)
	next.emit()

func transition():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	next.emit()

func dialog_runner(dialog_name: String):
	if !dialogue_is_running:
		ucing.disable_movement()
		dialogue_is_running = true
		Dialogic.start(dialog_name)
		await Dialogic.timeline_ended
		dialogue_is_running = false
		ucing.enable_movement()
		next.emit()
#endregion
