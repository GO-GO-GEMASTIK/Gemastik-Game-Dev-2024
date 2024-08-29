extends Node2D

var dialogue_is_running = false
var camera

@onready var ucing = $MC
@onready var buba = %Buba

var task1_scene = load("res://Storyline/4_Task 1/box_drag_drop.tscn")
var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if ucing and ucing.has_node("Camera2D"):
		camera = ucing.get_node("Camera2D")
		
	if GameStateManager.is_task_completed(1):
		ucing.set_global_position(Vector2(680,600))
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
			TransitionScreen.transition_between()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(tbc)
			
	elif !dialogue_is_running:
		dialogue_is_running = true
		ucing.disable_movement()
		Dialogic.start("gudang")
		await Dialogic.timeline_ended
		ucing.enable_movement()


func _on_box_start_task():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task1_scene)
