extends Node2D

signal next
signal next_part

@export var cula_kamera := Texture2D

@onready var ucing = $MC
@onready var camera = ucing.get_node("Camera2D")
@onready var animations = $CanvasLayer/Control/Animations
@onready var night_ambience = $NightAmbience
@onready var cula = $Cula
@onready var buba = $Buba
@onready var maung = $Maung
@onready var guide_animation = $CanvasLayer/GuideAnimation
@onready var task_animation = $TaskAnimation

var dialogue_is_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	ucing.look_left()
	if not GameStateManager.is_task_completed(5):
		run_part_1()
	elif GameStateManager.is_task_completed(5):
		run_part_3()

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
func run_part_1():
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
	run_part_2()
# ---
func run_part_2():
	play_animation("day2night")
	await next
	cula.set_visible(false)
	buba.set_visible(false)
	await next
	dialog_runner("B4_3_kamar_malam_kedua")
	await next
	guide_animation.play("show_guide")

# --task 5 here--

func run_part_3():
	buba.set_global_position(Vector2(2450, 821))
	cula.set_visible(false)
	ucing.set_global_position(Vector2(1080, 609))
	maung.set_global_position(Vector2(930, 855))
	await get_tree().create_timer(1.0).timeout
	dialog_runner("B4_4_orangtua_ucing_maung")
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
