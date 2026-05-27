extends Sprite2D

var fade_duration = 4.0 # Duration of the fade effect in seconds
var current_time = 0.0

func _process(delta):
	if current_time < fade_duration:
		current_time += delta
		var fade_amount = current_time / fade_duration # Calculate the amount of fade
		self.modulate.a = 1.0 - fade_amount # Adjust alpha value for fading
	else:
		# Free the node when fade out is complete
		queue_free()
