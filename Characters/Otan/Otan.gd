extends CharacterBody2D

@export var ucing: CharacterBody2D
@export var papan: Area2D
@export var SPEED: int = 390

@onready var otan_sprite = $OtanSprite

var JUMP_VELOCITY = -650.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_papan = false

# ---MOVEMENT AND FOLLOWING MECHANISM---
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle going to Area Papan
	if papan and is_papan:
		var direction = sign(papan.global_position.x - global_position.x)
		
		# Flip the sprite based on the direction of papan
		if papan.global_position.x > global_position.x:
			otan_sprite.set_flip_h(false)
		else:
			otan_sprite.set_flip_h(true)
			
		# Check if the NPC is close to Papan
		if global_position.distance_to(papan.global_position) < 450:
			if is_on_floor():
				velocity.x = 0  # Stop the NPC
				otan_sprite.set_animation("default")
				is_papan = false
		else:
			velocity.x = direction * SPEED
			otan_sprite.set_animation("walk")
			
		# Update the position
		move_and_slide()


func to_papan():
	is_papan = true

func set_flip_h(value: bool):
	otan_sprite.set_flip_h(value)
