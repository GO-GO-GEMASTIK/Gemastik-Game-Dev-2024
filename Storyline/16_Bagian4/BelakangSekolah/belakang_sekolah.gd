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

var scene_bukit = load("res://Storyline/16_Bagian4/Bukit/bukit.tscn")
var gasped := false
var bukit := false

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	camera.set_limit(SIDE_BOTTOM, 1600)
	camera.set_limit(SIDE_RIGHT, 11000)
	following.emit()

func _on_dialogic_signal(argument:String):
	if argument == "tembok":
		pass

func _input(event):
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
