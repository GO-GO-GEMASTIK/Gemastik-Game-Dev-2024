extends Node2D

signal following
signal r_in
signal r_out

@onready var ucing = $Chara/MC
@onready var camera: Camera2D = ucing.camera
@onready var buba = $Chara/Buba
@onready var maung = $Chara/Maung
@onready var chara = $Chara
@onready var guide_task = $CanvasLayer/GuideTask
@onready var pop = %Pop

var task_6 = load("res://Storyline/Bagian_4/Task 6/puzzle.tscn")
var hutan_b = load("res://Storyline/Bagian_4/Hutan/hutan_b.tscn")

var smooth_zoom:float = 0.8
var target_zoom:float = 0.6
var default_zoom:float = 0.8

const ZOOM_SPEED = 2

var interacted: bool = GameStateManager.get_string_state("InteractedCamera")
var next_scene: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	
	following.emit()
	camera.set_limit(SIDE_BOTTOM, 2300)
	camera.set_limit(SIDE_RIGHT, 10000)
	camera.set_zoom(Vector2(0.8,0.8))
	
	if GameStateManager.is_task_completed(6):
		part_2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("run"):
		ucing.change_speed_val(800)
		buba.change_speed_val(790)
		maung.change_speed_val(795)
		camera.set_limit_smoothing_enabled(false)
		smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != target_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
	else:
		ucing.change_speed_val(450)
		buba.change_speed_val(440)
		maung.change_speed_val(445)
		smooth_zoom = lerp(smooth_zoom, default_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != default_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
		if smooth_zoom == default_zoom:
			camera.set_limit_smoothing_enabled(true)


func part_1():
	ucing.disable_movement()
	
	Dialogic.start("B4_5_hutan_ketemu_kamera")
	await Dialogic.timeline_ended
	guide_task.set_visible(true)
	
func part_2():
	chara.set_global_position(Vector2(5200, 875))
	ucing.look_left()
	ucing.disable_movement()
	
	await get_tree().create_timer(1.0).timeout
	Dialogic.start("B4_6_hutan_after_kamera")
	await Dialogic.timeline_ended
	
	ucing.enable_movement()


func _on_area_camera_body_entered(body):
	if body == ucing and not interacted:
		GameStateManager.set_string_state("InteractedCamera", true)
		part_1()

func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_6)


func _on_area_next_body_entered(body):
	if body == ucing:
		pop.play()
		r_in.emit()
		next_scene = true

func _on_area_next_body_exited(body):
	if body == ucing:
		r_out.emit()
		next_scene = false


func _input(event):
	if event.is_action_pressed("talk") and next_scene:
		r_out.emit()
		TransitionScreen.transition_loading()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(hutan_b)
