extends CollisionShape2D

@onready var ucing = $"../../MC"

var camera
var task2 = load("res://Storyline/5_Task 2/math_class.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if ucing and ucing.has_node("Camera2D"):
		camera = ucing.get_node("Camera2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mc_global = ucing.global_position.x
	var self_global = self.global_position.x
	if (mc_global - self_global > -100) && (mc_global - self_global < 100):
		self.visible = true
		if Input.is_action_just_released("talk"):
			self.visible = false
			Dialogic.start("dialog_kelas")
			#ucing.disable_movement()
			Dialogic.timeline_ended.connect(_on_dialog_ended)
			await Dialogic.timeline_ended
			#ucing.enable_movement()
	

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
