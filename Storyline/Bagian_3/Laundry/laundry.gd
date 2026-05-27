extends Node2D

@export var is_bagian_3: bool = GameStateManager.get_string_state("Bagian3")

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera
@onready var tumpukan_baju = %TumpukanBaju
@onready var area_baju = %AreaBaju
@onready var animation = $AnimationPlayer
@onready var guide_task = %GuideTask
@onready var pop = %Pop
@onready var open_door = %OpenDoor

var right_limit = GameStateManager.get_room_right_limit("laundry")
var laundry_task = load("res://Storyline/Bagian_3/Task 3/laundry_drag_drop.tscn")
var main_room = load("res://Storyline/Bagian_1/Main Room/main_room.tscn")

var door := true
var task_3 := false
var to_main := false

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.set_limit(SIDE_RIGHT, right_limit)
	camera.reset_smoothing()
	if is_bagian_3:
		door = false
		if !GameStateManager.is_task_completed(3):
			tumpukan_baju.set_visible(true)
			area_baju.set_monitoring(true)
		else:
			after_task_3()
	else:
		door = true


func after_task_3():
	ucing.set_global_position(Vector2(840, 850))
	ucing.disable_movement()
	
	Dialogic.start("B3_after_laundry")
	await Dialogic.timeline_ended
	
	GameStateManager.set_string_state("DirectionKantin", true)
	animation.play("show_kantin")
	door = true
	ucing.enable_movement()


func _input(event):
	if event.is_action_pressed("talk"):
		if task_3:
			task_3 = false
			guide_task.set_visible(true)
		if to_main:
			open_door.play()
			animation.play("hide_door")
			animation.queue("hide_kantin")
			GameStateManager.set_pos_state("KeluarLaundry", true)
			
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(main_room)

func _on_area_baju_body_entered(body):
	if body == ucing:
		pop.play()
		animation.play("show_task")
		animation.queue("float_task")
		task_3 = true
func _on_area_baju_body_exited(body):
	if body == ucing:
		animation.play("hide_task")
		task_3 = false

func _on_area_pintu_body_entered(body):
	if body == ucing and door:
		pop.play()
		animation.play("show_door")
		animation.queue("float_door")
		to_main = true
func _on_area_pintu_body_exited(body):
	if body == ucing and door:
		animation.play("hide_door")
		to_main = false

func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(laundry_task)

