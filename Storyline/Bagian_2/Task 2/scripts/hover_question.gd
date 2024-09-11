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
	
	# Check if the mouse is near the sprite
	if distance_to_mouse < threshold_distance:
		# Change animation when the mouse is near
		# Replace "animation_name" with the name of the animation you want to play
		self.animation = "hover"
	else:
		# Change back to default animation when the mouse moves away
		self.animation = "default"

func _input(event):
	pass
