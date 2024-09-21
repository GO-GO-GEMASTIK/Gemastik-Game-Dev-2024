extends Area2D

@export var player: CharacterBody2D
@onready var otan = $OtanSprite
@onready var icon_player = $AnimationPlayer

func _physics_process(_delta):
	if player:
		# Calculate the direction to the player
		var direction_to_player = player.global_position - global_position

		# Flip the character otan horizontally based on the direction
		if direction_to_player.x < 0:
			# If player is to the left, flip character otan
			if otan:
				otan.flip_h = true
		else:
			# If player is to the right, reset character otan
			if otan:
				otan.flip_h = false


func _on_body_entered(body):
	if body.name == "MC":
		icon_player.play("show_chat")
		icon_player.queue("float_chat")
		$PopSound.play()


func _on_body_exited(body):
	if body.name == "MC":
		icon_player.play("hide_chat")
