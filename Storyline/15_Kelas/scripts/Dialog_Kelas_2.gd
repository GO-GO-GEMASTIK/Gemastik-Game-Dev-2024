extends Area2D
@onready var ucing = $"../MC"
@onready var views = $"Area2D/AnimatedSprite2D"
var camera
var task2 = load("res://Storyline/5_Task 2/math_class.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	#views.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func _on_body_entered(body):
	Dialogic.start("dialog_kelas")
	ucing.disable_movement()
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	await Dialogic.timeline_ended
	ucing.enable_movement() # Replace with function body.

func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task2)
	

func _on_dialogic_signal(argument:String):
	if argument == "1":
		print("Baik")
		GameStateManager.set_naughty_nice("Kerjasama","1")
		GameStateManager.get_naughty_nice("Kerjasama")
	elif argument == "0":
		print("Ga baik")
		GameStateManager.set_naughty_nice("Kerjasama","0")
		GameStateManager.get_naughty_nice("Kerjasama")
	else:
		print("Ndak masuk")

func _on_body_exited(body):
	if body.name == "MC":
		views.visible=false


func _input(event):
	if event.is_action_pressed("talk"):
		pass

