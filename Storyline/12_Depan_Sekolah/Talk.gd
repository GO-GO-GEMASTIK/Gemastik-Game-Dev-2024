extends CollisionShape2D

@onready var mc=  $"../MC"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mc_global = mc.global_position.x
	var self_global = self.global_position.x
	
	if (mc_global - self_global > -600) || (mc_global - self_global < 600):
		if Input.is_action_just_released("talk"):
			Dialogic.start("dialog_trio_hutan")
