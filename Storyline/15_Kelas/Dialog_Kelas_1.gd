extends CollisionShape2D

@onready var mc=  $"../MC"
var task2 = load("res://Storyline/5_Task 2/math_class.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mc_global = mc.global_position.x
	var self_global = self.global_position.x
	
	print(mc_global - self_global)
	if (mc_global - self_global > -100) && (mc_global - self_global < 100):
		self.visible = true
		if Input.is_action_just_released("talk"):
			self.visible = false
			Dialogic.start("dialog_kelas")
			Dialogic.timeline_ended.connect(_on_dialog_ended)
	

func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task2)
