extends CharacterBody2D

@export var ucing: CharacterBody2D

@onready var maung_sprite = $MaungSprite

const SPEED = 400.0
var JUMP_VELOCITY = -650.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var following = false
var waiting = false
var called = false
var jumping = false

# ---MOVEMENT AND FOLLOWING MECHANISM---
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump
	if is_on_floor() and jumping:
		velocity.y = JUMP_VELOCITY
		
	if ucing and following:
		# Get the direction to the main character
		var direction = sign(ucing.global_position.x - global_position.x)
		
		# Flip the sprite based on the direction of ucing
		if ucing.global_position.x > global_position.x:
			maung_sprite.set_flip_h(false)
		else:
			maung_sprite.set_flip_h(true)
			
		# Check if the NPC is close to the main character
		if global_position.distance_to(ucing.global_position) < 200:
			if is_on_floor():
				velocity.x = 0  # Stop the NPC
				called = false
		else:
			if not called:
				start_waiting()
				called = true
			if not waiting:
				velocity.x = direction * SPEED
		# Update the position
		move_and_slide()

func _following():
	self.set_visible(true)
	set_following(true)

func set_following(value: bool):
	following = value

func set_flip_h(value: bool):
	maung_sprite.set_flip_h(value)

# Coroutine to introduce delay before continuing
func start_waiting():
	waiting = true
	await get_tree().create_timer(0.3).timeout  # 100 ms delay
	waiting = false


func jump():
	jumping = true

func jump_stop():
	jumping = false

func change_jump_val(val: int):
	JUMP_VELOCITY = val
