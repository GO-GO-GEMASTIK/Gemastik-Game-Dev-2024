extends Sprite2D

var fade_duration = 3.0 # Duration of the fade in seconds
var current_time = 0.0 # Current time elapsed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_time < fade_duration:
		current_time += delta
		var fade_amount = current_time / fade_duration # Calculate the amount of fade
		modulate.a = 1.0 - fade_amount # Adjust alpha value for fading
		 # Free the node when fade out is complete
