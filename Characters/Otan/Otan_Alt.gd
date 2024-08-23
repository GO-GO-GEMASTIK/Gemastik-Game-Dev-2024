extends Area2D

@onready var player= $"../MC"
@onready var otan = $Sprite2D

func _physics_process(_delta):
	if player:
		# Calculate the direction to the player
		var direction_to_player = player.global_position - global_position
		# Flip the character otan horizontally based on the direction
		if direction_to_player.x < 700:
			# If player is to the left, flip character otan
			if otan:
				otan.flip_h = true
		else:
			# If player is to the right, reset character otan
			if otan:
				otan.flip_h = false
