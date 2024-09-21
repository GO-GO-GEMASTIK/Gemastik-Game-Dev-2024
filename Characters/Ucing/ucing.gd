extends CharacterBody2D

@export var SPEED := 450.0
@export var flip_h := false

@onready var ucing = $Sprite2D
@onready var walking_sound = $Walk
@onready var camera: Camera2D = $Camera2D
@onready var timer = $Timer

var JUMP_VELOCITY = -450.0
var movement_enabled = true
var last_facing_left = false
var push_force = 80.0

var is_duduk = false
var walked = false
var can_jump = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	ucing.set_flip_h(flip_h)

func _physics_process(delta):
#region ANIMATION AND MOVEMENT MECHANICS
	if (velocity.x > 1 || velocity.x < -1):
		if !is_duduk:
			ucing.animation = "walk"
			if timer.time_left <= 0:
				walking_sound.pitch_scale = randf_range(0.8, 1.2)
				walking_sound.play()
				timer.start(0.2)
	else:
		if !is_duduk:
			walking_sound.stop()
			ucing.animation = "idle"

	# Add the gravity.
	if not is_on_floor() and movement_enabled:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and movement_enabled and can_jump:
		velocity.y = JUMP_VELOCITY
		if walking_sound.playing:
			walking_sound.stop()

	# Get the input direction and handle the movement/deceleration.
	if movement_enabled:
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			
			# Update last facing direction
			if direction < 0:
				last_facing_left = true
			elif direction > 0:
				last_facing_left = false
		else:
			velocity.x = move_toward(velocity.x, 0, 20)
		
		# Play or stop walking sound based on movement and ground state...
	
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	# Set sprite flip based on the last direction faced
	ucing.flip_h = last_facing_left
#endregion =============================================

func walking():
	walked = true
	if walked:
		walking_sound.play()
		walked = false


#region MOVEMENT & CAMERA
func disable_movement():
	movement_enabled = false
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.y = 0
	if !is_duduk:
		ucing.animation = "idle"
	if walking_sound.playing:
		walking_sound.stop()

func enable_movement():
	movement_enabled = true

func disable_jump():
	can_jump = false

func enable_jump():
	can_jump = true

func enable_camera():
	camera.set_enabled(true)

func disable_camera():
	camera.set_enabled(false)
#endregion


#region FACING DIRECTION
func look_left():
	last_facing_left = true
	ucing.flip_h = true

func look_right():
	last_facing_left = false
	ucing.flip_h = false

func is_looking_left() -> bool:
	return ucing.is_flipped_h()

func duduk():
	is_duduk = true
	ucing.set_animation("duduk")

func berdiri():
	is_duduk = false
	ucing.set_animation("idle")
#endregion


#region MOVEMENT MODIFIER
func change_jump_val(val: int):
	JUMP_VELOCITY = val

func change_speed_val(val: int):
	SPEED = val
#endregion
