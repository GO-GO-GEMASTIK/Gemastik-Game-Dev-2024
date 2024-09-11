extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get the position of the mouse relative to the current node
	var mouse_position = get_global_mouse_position()
	var distance_to_mouse = global_position.distance_to(mouse_position)
	
	# Define the threshold distance for changing animation
	var threshold_distance = 100
	
	# Check if the mouse is near the sprite
	if distance_to_mouse < threshold_distance:
		# Change animation when the mouse is near
		# Replace "animation_name" with the name of the animation you want to play
		self.animation = "mouse"
	else:
		# Change back to default animation when the mouse moves away
		self.animation = "default"

func _input(event):
	# Check if the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Check if the mouse click is inside the sprite's bounding box
			if self.animation == "mouse":
				# Transition to the next scene when the sprite is clicked
				get_tree().change_scene_to_file("res://Storyline/Bagian_1/Main Room/subscenes/intro_dialogue.tscn")
