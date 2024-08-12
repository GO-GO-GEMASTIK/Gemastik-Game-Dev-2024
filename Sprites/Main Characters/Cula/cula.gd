extends Area2D

@onready var player= $"../MC"
@onready var cula = $AnimatedSprite2D

func _physics_process(_delta):
	if player:
		# Calculate the direction to the player
		var direction_to_player = player.global_position - cula.global_position
		print("Cula ",direction_to_player)
		# Flip the character otan horizontally based on the direction
		if direction_to_player.x < -200:
			
			# If player is to the left, flip character otan
			if cula:
				cula.flip_h = true
		else:
			# If player is to the right, reset character otan
			if cula:
				cula.flip_h = false
	else:
		print("Ucing, aku takut!")
