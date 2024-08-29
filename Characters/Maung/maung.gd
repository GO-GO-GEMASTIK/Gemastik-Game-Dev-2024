extends Area2D

@onready var player= $"../MC"
@onready var maung = $Sprite2D

func _physics_process(_delta):
	if player:
		# Calculate the direction to the player
		var direction_to_player = player.global_position - global_position

		# Flip the character otan horizontally based on the direction
		if direction_to_player.x < 300:
			# If player is to the left, flip character otan
			if maung:
				maung.flip_h = true
		else:
			# If player is to the right, reset character otan
			if maung:
				maung.flip_h = false
	else:
		pass
