extends Node2D

var dialogue_is_running = false

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera
@onready var buba = %Buba
@onready var right_limit = GameStateManager.get_room_right_limit("gudang")

var task1_scene = load("res://Storyline/4_Task 1/box_drag_drop.tscn")
var kelas = load("res://Storyline/Bagian_2/Kelas/kelas.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	camera.set_limit(SIDE_RIGHT, right_limit)

	if GameStateManager.is_task_completed(1):
		ucing.set_global_position(Vector2(680,835))
		buba.set_global_position(Vector2(1000, 805))
		camera.position = Vector2(0,0)
		camera.reset_smoothing()
		buba.set_visible(true)
		
		await get_tree().create_timer(1.0).timeout
		if !dialogue_is_running:
			dialogue_is_running = true
			ucing.disable_movement()
			ucing.get_tree()
			
			Dialogic.start("box_selesai")
			await Dialogic.timeline_ended
			
			dialogue_is_running = false
			GameStateManager.set_string_state("Bagian2", true)
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(kelas)
			
	elif !dialogue_is_running:
		dialogue_is_running = true
		ucing.disable_movement()
		Dialogic.start("gudang")
		await Dialogic.timeline_ended
		ucing.enable_movement()

func _on_dialogic_signal(argument:String):
	if argument == "menghargai":
		GameStateManager.set_characteristic("Menghargai", true)


func _on_box_start_task():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task1_scene)
