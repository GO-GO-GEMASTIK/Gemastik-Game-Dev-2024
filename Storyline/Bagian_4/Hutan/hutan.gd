extends Node2D

signal following

@onready var ucing = $MC
@onready var camera: Camera2D = $MC.camera
@onready var buba = $Buba
@onready var maung = $Maung

var smooth_zoom:float = 0.8
var target_zoom:float = 0.5
var default_zoom:float = 0.8

const ZOOM_SPEED = 4

var interacted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	following.emit()
	camera.set_limit(SIDE_BOTTOM, 2300)
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
		ucing.change_speed_val(400)
		buba.change_speed_val(390)
		maung.change_speed_val(395)
		smooth_zoom = lerp(smooth_zoom, default_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != default_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
		if smooth_zoom == default_zoom:
			camera.set_limit_smoothing_enabled(true)


func _on_area_camera_body_entered(body):
	if body == ucing and not interacted:
		interacted = true
		part_1()

func _on_area_camera_body_exited(body):
	pass # Replace with function body.

func part_1():
	ucing.disable_movement()
	
	Dialogic.start("B4_5_hutan_ketemu_kamera")
	await Dialogic.timeline_ended
	
	ucing.enable_movement()
	
	
