extends Area2D

@onready var task_warning = %TaskWarning
@onready var task_player = %TaskPlayer
@onready var guide_player = %GuidePlayer

var on_meja := false
var task_completed := GameStateManager.is_task_completed(5)
var task_5 = preload("res://Storyline/16_Bagian4/Task 5/finding_item.tscn")
var show_task := false

# !!!CURRENTLY DEBUGGING, DO NOT FORGET TO SET TO DEFAULT!!!

func _ready():
# PRELOAD TIMELINE TO REDUCE LAG
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "task_5":
		show_task = true


func _input(event):
	if event.is_action_pressed("talk") and on_meja and !task_completed:
		task_warning.set_visible(true)


func _on_body_entered(body):
	if body.name == "MC" and show_task:
		guide_player.play("hide_guide")
		task_player.play("show_task")
		task_player.queue("task_floating")
		on_meja = true

func _on_body_exited(body):
	if body.name == "MC" and show_task:
		task_player.play("hide_task")
		guide_player.play("show_guide")
		on_meja = false


func _on_button_pressed():
	await get_tree().create_timer(1.0).timeout
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_5)
