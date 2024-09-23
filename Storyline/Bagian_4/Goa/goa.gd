extends Node2D

signal following

@onready var ucing = $Chara/MC
@onready var camera: Camera2D = ucing.camera
@onready var ucing_dkk = $Chara
@onready var otan_cula = $OtanCula
@onready var buba = $Chara/Buba
@onready var maung = $Chara/Maung
@onready var cula = $OtanCula/Cula
@onready var otan = $OtanCula/Otan
@onready var torachan = $Torachan

@onready var animasi_kelelawar = $SaveGame/AnimasiKelelawar
@onready var guide_task_8 = $SaveGame/GuideTask8
@onready var guide_task_7 = $SaveGame/GuideTask7
@onready var darken = $FrontLayout/Darken
@onready var animation = $AnimationPlayer
@onready var pop = %Pop
@onready var torawr = $Sounds/Torawr
@onready var maung_1 = $Sounds/Maung
@onready var maung_2 = $Sounds/Maung2
@onready var maung_3 = $Sounds/Maung3

var task_8 = load("res://Storyline/Bagian_4/Task 8/senter_game_1.tscn")
var task_7 = load("res://Storyline/Bagian_4/Task 7/lock_pick_1.tscn")
var closing = load("res://Storyline/Closing/closing_animation.tscn")

@export var random_strength: float = 40.0
@export var shake_fade: float = 3.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

@export var run_offset = 50
@export var offset_speed = 5
var default_offset = 0
var current_offset = 0

var on_lock: bool = false
var rawr: bool = false

@export var debug: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.reset_smoothing()
	camera.set_limit(SIDE_RIGHT, 12950)
	camera.set_limit(SIDE_LEFT, 50)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	cula.set_flip_h(true)
	otan.set_flip_h(true)
	
	if debug:
		after_lock()
	else:
		if !GameStateManager.is_task_completed(8) and !debug:
			before_senter()
		else:
			if !GameStateManager.is_task_completed(7):
				following.emit()
				after_senter()
			else:
				after_lock()

func _on_dialogic_signal(argument:String):
	if argument == "pan_camera":
		camera.set_position(Vector2(11600, 0))
	if argument == "menghargai":
		GameStateManager.set_characteristic("Menghargai", true)
	if argument == "rawr":
		rawr = true
		torawr.play()
	if argument == "rawr_maung":
		shake_fade = 1.0
		rawr = true
	if argument == "maung1":
		maung_1.play()
	if argument == "maung2":
		maung_2.play()
	if argument == "maung3":
		maung_3.play()
	if argument == "pan_normal":
		camera.set_position(Vector2.ZERO)
	if argument == "pan_to_monster":
		camera.set_global_position(torachan.get_global_position())
	if argument == "pan_to_maung":
		ucing.look_left()
		maung.set_flip_h(true)
		buba.set_flip_h(true)
		camera.set_global_position(maung.get_global_position())

#region STORYLINE
func before_senter():
	darken.set_visible(true)
	ucing.disable_movement()
	
	await get_tree().create_timer(1.0).timeout
	animasi_kelelawar.set_visible(true)
	animasi_kelelawar.play("default")
	
	print("MULAI DIALOG")
	Dialogic.start("B4_7_dalam_goa")
	await Dialogic.timeline_ended
	
	guide_task_8.set_visible(true)

func after_senter():
	ucing.disable_movement()
	
	Dialogic.start("B4_8_senter_fixed")
	await Dialogic.timeline_ended
	
	ucing.enable_movement()

func after_lock():
	ucing.disable_movement()

	ucing_dkk.set_global_position(Vector2(11500, 700))
	otan_cula.set_global_position(Vector2(11832, 707))
	ucing.set_position(Vector2(210, 30))
	maung.set_position(Vector2(-191, 1))
	buba.set_position(Vector2(26, -29))
	camera.reset_smoothing()
	
	ucing.look_right()
	maung.set_flip_h(false)
	buba.set_flip_h(false)
	torachan.set_visible(true)
	
	await get_tree().create_timer(1.0).timeout
	
	Dialogic.start("B4_9_after_gembok")
	await Dialogic.timeline_ended
	
	await get_tree().create_timer(1.0).timeout
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	monster_locked()

func monster_locked():
	ucing.disable_movement()
	camera.set_position(Vector2.ZERO)
	ucing_dkk.set_global_position(Vector2(11800, 700))
	otan_cula.set_global_position(Vector2(11360, 713))
	torachan.set_global_position(Vector2(12500, 470))
	ucing.set_position(Vector2(202, 35))
	maung.set_position(Vector2(2, 1))
	buba.set_position(Vector2(-128, -29))
	
	ucing.look_right()
	cula.set_flip_h(false)
	otan.set_flip_h(false)
	buba.set_flip_h(false)
	maung.set_flip_h(false)
	torachan.set_flip_h(true)
	
	Dialogic.start("B4_10_monster_end")
	#Dialogic.start("placeholder")
	await Dialogic.timeline_ended
	
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(closing)

#endregion


#region SIGNALS
func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_8)

func _on_area_kandang_body_entered(body):
	if body == ucing and !GameStateManager.is_task_completed(7):
		pop.play()
		on_lock = true
		animation.play("show_task")
		animation.queue("float_task")

func _on_area_kandang_body_exited(body):
	if body == ucing and !GameStateManager.is_task_completed(7):
		on_lock = false
		animation.play("hide_task")

func _on_button_lock_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_7)

func _input(event):
	if event.is_action_pressed("talk"):
		if on_lock:
			guide_task_7.set_visible(true)
#endregion


#region SHAKING MECHANISM
func _process(delta):
	if rawr:
		apply_shake()
		rawr = false
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		camera.offset = random_offset()
	
	if Input.is_action_pressed("run"):
		ucing.change_speed_val(800)
		buba.change_speed_val(790)
		maung.change_speed_val(795)
		
		if ucing.is_looking_left():
			current_offset = lerpf(current_offset, run_offset, offset_speed * delta)
			if current_offset < run_offset:
				camera.set_offset(Vector2(current_offset, 0))
		else:
			current_offset = lerpf(current_offset, -run_offset, offset_speed * delta)
			if current_offset < run_offset:
				camera.set_offset(Vector2(current_offset, 0))
	else:
		ucing.change_speed_val(400)
		buba.change_speed_val(390)
		maung.change_speed_val(395)
		
		current_offset = lerpf(current_offset, default_offset, offset_speed * delta)
		if current_offset != default_offset:
			camera.set_offset(Vector2(current_offset, 0))


func apply_shake():
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
#endregion
















