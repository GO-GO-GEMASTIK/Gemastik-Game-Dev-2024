extends CharacterBody2D

@export var SPEED := 500.0
const JUMP_VELOCITY = -400.0

@onready var ucing = $Sprite2D
@onready var walking_sound = $Walk
@onready var camera = $Camera2D
@onready var good_bad_traits_script: Script = preload("res://Utility/GoodBadTraits.gd")

var movement_enabled = true
var last_facing_left = false

func _ready():
	if owner.name == "Main":
		camera.set_position_smoothing_enabled(false)
		global_position = GameStateManager.get_pos_main()
		camera.position = Vector2.ZERO
		await get_tree().create_timer(0.5).timeout
		camera.set_position_smoothing_enabled(true)
		
	#good_bad_traits_script = good_bad_traits_script.new()


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
#region ANIMATION AND MOVEMENT MECHANICS
	if (velocity.x > 1 || velocity.x < -1):
		ucing.animation = "walk"
	else:
		ucing.animation = "idle"

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and movement_enabled:
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
			velocity.x = move_toward(velocity.x, 0, SPEED-50)
		
		# Play or stop walking sound based on movement and ground state...
	
	move_and_slide()

	# Set sprite flip based on the last direction faced
	ucing.flip_h = last_facing_left
#endregion =============================================
	

func disable_movement():
	movement_enabled = false
	velocity.x = move_toward(velocity.x, 0, SPEED)
	ucing.animation = "idle"
	if walking_sound.playing:
		walking_sound.stop()

func enable_movement():
	movement_enabled = true

func look_left():
	last_facing_left = true
	ucing.flip_h = true

func look_right():
	last_facing_left = false
	ucing.flip_h = false



func _on_dialogic_game_handler_signal_event(argument):
	#print(argument)
	good_bad_traits_script._change_traits(argument)
