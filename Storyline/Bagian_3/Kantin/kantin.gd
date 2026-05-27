extends Node2D

@export var is_bagian_3: bool = GameStateManager.get_string_state("Bagian3")

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera
@onready var meja = %Meja
@onready var area_makan = %AreaMakan
@onready var animation = $AnimationPlayer
@onready var pop = %Pop

var right_limit = GameStateManager.get_room_right_limit("kantin")
var food_task = load("res://Storyline/Bagian_3/Task 4/food_making.tscn")
var main_room = load("res://Storyline/Bagian_1/Main Room/main_room.tscn")
var kamar = load("res://Storyline/Bagian_4/Kamar/kamar.tscn")

var door := true
var task_4 := false
var to_main := false

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.set_limit(SIDE_RIGHT, right_limit)
	camera.reset_smoothing()
	if is_bagian_3:
		door = false
		if !GameStateManager.is_task_completed(4):
			area_makan.set_monitoring(true)
		else:
			after_food_task()
	else:
		door = true

func after_food_task():
	ucing.disable_movement()
	ucing.set_global_position(Vector2(1660, 850))
	
	Dialogic.start("B3_after_food")
	await Dialogic.timeline_ended
	
	GameStateManager.set_string_state("Bagian3", false)
	GameStateManager.set_string_state("Bagian4", true)
	await get_tree().create_timer(1.0).timeout
	
	TransitionScreen.transition_loading()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(kamar)

func _input(event):
	if event.is_action_pressed("talk"):
		if task_4:
			task_4 = false
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(food_task)
		if door:
			door = false
			GameStateManager.set_pos_state("KeluarKantin", true)
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(main_room)

func _on_area_makan_body_entered(body):
	if body == ucing:
		pop.play()
		animation.play("show_task")
		animation.queue("float_task")
		task_4 = true

func _on_area_makan_body_exited(body):
	if body == ucing:
		animation.play("hide_task")
		task_4 = false


func _on_area_pintu_body_entered(body):
	if body == ucing and door:
		animation.play("show_door")
		animation.queue("float_door")
		to_main = true

func _on_area_pintu_body_exited(body):
	if body == ucing and door:
		animation.play("hide_door")
		to_main = true
