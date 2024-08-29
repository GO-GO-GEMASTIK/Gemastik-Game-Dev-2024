extends Area2D

@onready var task_animation = %TaskAnimation
@onready var guide_animation = $"../../CanvasLayer/GuideAnimation"
@onready var task_5 = load("res://Storyline/8_Task 5/finding_item.tscn")
@onready var task_warning = %TaskWarning

var on_meja := false
var task_completed := GameStateManager.is_task_completed(5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("talk") and on_meja and !task_completed:
		task_warning.set_visible(true)


func _on_body_entered(body):
	if body.name == "MC" and !task_completed:
		guide_animation.play("hide_guide")
		task_animation.play("show_task")
		task_animation.queue("task_floating")
		on_meja = true


func _on_body_exited(body):
	if body.name == "MC" and !task_completed:
		task_animation.play("hide_task")
		guide_animation.play("show_guide")
		on_meja = false


func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task_5)
