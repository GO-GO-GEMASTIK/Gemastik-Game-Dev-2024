extends AnimatedSprite2D

@onready var base = $"../../TextureRect/BaseLight"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get the position of the mouse relative to the current node
	var mouse_position = get_global_mouse_position()
	var distance_to_mouse = global_position.distance_to(mouse_position)
	#print("Mouse ",mouse_position)
	#print("Distance ",distance_to_mouse)
	# Define the threshold distance for changing animation
	var threshold_distance = 300
	


func _input(event):
	pass


func _on_question_1_mouse_entered():
	self.animation = "hover"

func _on_question_1_mouse_exited():
	self.animation = "default"

