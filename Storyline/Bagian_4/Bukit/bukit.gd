extends Node2D

signal following
signal r_in
signal r_out

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera
@onready var buba = $Buba
@onready var maung = $Maung

var hutan := false
var kawasan_hutan_dialog := false
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")
var hutan_scene = load("res://Storyline/Bagian_4/Hutan/hutan.tscn")

var smooth_zoom:float = 0.9
var target_zoom:float = 0.7
var default_zoom:float = 0.9

const ZOOM_SPEED = 2

# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.preload_timeline("res://Dialogue/Timelines/empty_timeline.dtl")
	following.emit()
	camera.set_limit(SIDE_RIGHT, GameStateManager.get_room_right_limit("bukit"))
	camera.set_limit(SIDE_BOTTOM, 2698)
	camera.set_zoom(Vector2(0.9,0.9))

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

func _input(event):
	if event.is_action_pressed("talk"):
		if hutan:
			r_out.emit()
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(hutan_scene)


func _on_next_area_body_entered(body):
	if body == ucing:
		hutan = true
		r_in.emit()

func _on_next_area_body_exited(body):
	if body == ucing:
		hutan = false
		r_out.emit()


func _on_hutan_area_body_entered(body):
	if body == ucing and !kawasan_hutan_dialog:
		ucing.disable_movement()
		
		Dialogic.start("B4_kawasan_hutan")
		await Dialogic.timeline_ended
		
		ucing.enable_movement()
		kawasan_hutan_dialog = true
