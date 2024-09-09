extends Node2D

@onready var ucing = $MC
@onready var camera: Camera2D = $MC.camera

var smooth_zoom:float = 0.8
var target_zoom:float = 0.5
var default_zoom:float = 0.8

const ZOOM_SPEED = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.set_limit(SIDE_BOTTOM, 3780)
	camera.set_limit(SIDE_RIGHT, 10000)
	camera.set_zoom(Vector2(0.8,0.8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("run"):
		ucing.change_speed_val(1000)
		camera.set_limit_smoothing_enabled(false)
		smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != target_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
	else:
		ucing.change_speed_val(400)
		smooth_zoom = lerp(smooth_zoom, default_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != default_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
		if smooth_zoom == default_zoom:
			camera.set_limit_smoothing_enabled(true)
