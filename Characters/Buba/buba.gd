extends CharacterBody2D

@export var ucing: CharacterBody2D
@export var papan: Area2D
@export var SPEED: int = 440

@onready var buba_sprite = $BubaSprite
@onready var collision_shape_2d = $CollisionShape2D

var JUMP_VELOCITY = -650.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var following = false
var waiting = false
var called = false
var jumping = false
var is_papan = false
var is_duduk = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if (velocity.x > 1 || velocity.x < -1):
		if !is_duduk:
			buba_sprite.animation = "walk"
	else:
		if !is_duduk:
			buba_sprite.animation = "default"
	
		# Handle Jump
	if is_on_floor() and jumping:
		velocity.y = JUMP_VELOCITY
	
	# Handle Following Ucing
	if ucing and following:
		# Get the direction to the main character
		var direction = sign(ucing.global_position.x - global_position.x)
		
		# Flip the sprite based on the direction of ucing
		if ucing.global_position.x > global_position.x:
			buba_sprite.set_flip_h(false)
		else:
			buba_sprite.set_flip_h(true)
			
		# Check if the NPC is close to the main character
		if global_position.distance_to(ucing.global_position) < 400:
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
		
	# Handle going to Area Papan
	if papan and is_papan:
		var direction = sign(papan.global_position.x - global_position.x)
		
		# Flip the sprite based on the direction of papan
		if papan.global_position.x > global_position.x:
			buba_sprite.set_flip_h(false)
		else:
			buba_sprite.set_flip_h(true)
			
		# Check if the NPC is close to Papan
		if global_position.distance_to(papan.global_position) < 150:
			if is_on_floor():
				velocity.x = 0  # Stop the NPC
				set_flip_h(false)
				is_papan = false
		else:
			velocity.x = direction * SPEED
		# Update the position
		move_and_slide()

func _following():
	self.set_visible(true)
	set_following(true)

func set_following(value: bool):
	following = value

func to_papan():
	berdiri()
	is_papan = true

func set_flip_h(value: bool):
	buba_sprite.set_flip_h(value)

# Jumping
func jump():
	jumping = true

func jump_stop():
	jumping = false

func change_jump_val(val: int):
	JUMP_VELOCITY = val

func change_speed_val(val: int):
	SPEED = val

# Coroutine to introduce delay before continuing
func start_waiting():
	waiting = true
	await get_tree().create_timer(0.3).timeout  # 100 ms delay
	waiting = false
	

func duduk():
	is_duduk = true
	buba_sprite.set_animation("duduk")
	
func berdiri():
	is_duduk = false
	buba_sprite.set_animation("default")
