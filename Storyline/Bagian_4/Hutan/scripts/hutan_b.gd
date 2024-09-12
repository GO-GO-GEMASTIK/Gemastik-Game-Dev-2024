extends Node2D

signal following
signal r_in
signal r_out

@onready var ucing = $Chara/MC
@onready var camera: Camera2D = ucing.camera
@onready var buba = $Chara/Buba
@onready var maung = $Chara/Maung
@onready var chara = $Chara
@onready var pop = %Pop

var hutan_c = load("res://Storyline/Bagian_4/Hutan/hutan_c.tscn")

var smooth_zoom:float = 0.8
var target_zoom:float = 0.6
var default_zoom:float = 0.8

const ZOOM_SPEED = 2

var next_scene: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	
	following.emit()
	camera.set_limit(SIDE_BOTTOM, 3780)
	camera.set_limit(SIDE_RIGHT, 10000)
	camera.set_zoom(Vector2(0.8,0.8))

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
		ucing.change_speed_val(400)
		smooth_zoom = lerp(smooth_zoom, default_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != default_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
		if smooth_zoom == default_zoom:
			camera.set_limit_smoothing_enabled(true)


func _on_area_next_body_entered(body):
	if body == ucing:
		pop.play()
		r_in.emit()
		next_scene = true

func _on_area_next_body_exited(body):
	if body == ucing:
		r_out.emit()
		next_scene = false


func  _input(event):
	if event.is_action_pressed("talk"):
		r_out.emit()
		TransitionScreen.transition_loading()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(hutan_c)
