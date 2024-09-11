extends Node2D

signal following
signal r_in
signal r_out
signal jump_on
signal jump_off

@onready var ucing = $MC
@onready var buba = $Buba
@onready var maung = $Maung
@onready var camera: Camera2D = ucing.camera
@onready var small_box = $SmallBox
@onready var animation = $CanvasLayer/AnimationPlayer

var scene_bukit = load("res://Storyline/Bagian_4/Bukit/bukit.tscn")
var gasped := false
var bukit := false
var guide_lari := false
var runable := false

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
	Dialogic.signal_event.connect(_on_dialogic_signal)
	camera.set_limit(SIDE_BOTTOM, 1600)
	camera.set_limit(SIDE_RIGHT, 11000)
	camera.set_zoom(Vector2(0.9,0.9))
	camera.reset_smoothing()
	following.emit()

func _on_dialogic_signal(argument:String):
	if argument == "tembok":
		pass

func _process(delta):
	if runable:
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
	if event.is_action_pressed("run") and guide_lari:
		guide_lari = false
		animation.play("hide_lari")
	if bukit and event.is_action_pressed("talk"):
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(scene_bukit)


func _on_jump_area(body):
	if body.name == "MC":
		ucing.change_jump_val(-650)
		print(get_name())
	if body.name == "Buba" or body.name == "Maung":
		jump_on.emit()


func _on_jump_area_exited(body):
	if body.name == "MC":
		ucing.change_jump_val(-450)
	if body.name == "Buba":
		jump_off.emit()


func _on_next_area_body_entered(body):
	if body.name == "MC":
		r_in.emit()
		bukit = true

func _on_next_area_body_exited(body):
	if body.name == "MC":
		r_out.emit()
		bukit = false


func _on_pan_camera_body_entered(body):
	if not gasped:
		ucing.disable_movement()
		camera.set_position(Vector2(1111,0))
		
		await get_tree().create_timer(0.5).timeout
		Dialogic.start_timeline("B4_melihat_tembok")
		await Dialogic.timeline_ended
		
		camera.set_position(Vector2(0,0))
		ucing.enable_movement()
		gasped = true


func _on_small_box_move_friends():
	buba.set_global_position(Vector2(1373,1316))
	maung.set_global_position(Vector2(1476,1346))


func _on_bridge_area_body_entered(body):
	if body.name == "Buba":
		buba.change_jump_val(-450)
		maung.change_jump_val(-450)
		jump_on.emit()

func _on_bridge_area_body_exited(body):
	if body.name == "Buba":
		jump_off.emit()

func show_lari():
	guide_lari = true
	runable = true
	animation.play("show_lari")




