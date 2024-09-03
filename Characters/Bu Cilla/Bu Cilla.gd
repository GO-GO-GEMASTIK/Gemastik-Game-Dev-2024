extends Area2D

@onready var ucing = $"../MC"
@onready var bu_cilla = $SpriteBuCilla
@onready var tugas = $"../Tugas"

var fade_duration = 2.0  # Duration of fade-in/out in seconds
var fade_speed = 0.0
var fading_in = false
var fading_out = false

func _ready():
	# Start dialog
	#ucing.disable_movement()
	Dialogic.start("dialog_perkenalan")
	
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	
	

func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
	# Start the fade-in effect after dialogue ends
	# Ensure Tugas is visible during fade-in
	ucing.enable_movement()
	tugas.visible = true
	tugas.modulate.a = 0
	
	start_fade_in()
		# Set initial alpha
		
func _physics_process(_delta):
	if ucing:
		# Calculate the direction to the player
		var direction_to_player = ucing.global_position - global_position

		# Flip the character horizontally based on the direction
		if direction_to_player.x < 100:
			# If player is to the left, flip character
			if bu_cilla:
				bu_cilla.flip_h = true
		else:
			# If player is to the right, reset character
			if bu_cilla:
				bu_cilla.flip_h = false
	
func _process(delta):
	
	if tugas.global_position.x - ucing.global_position.x > 400:
		start_fade_out()
		
	if fading_in:
		# Increase the alpha value
		tugas.modulate.a += fade_speed * delta
		if tugas.modulate.a >= 1.0:
			tugas.modulate.a = 1.0
			fading_in = false  # Stop fading in
	
	if fading_out:
		# Decrease the alpha value
		tugas.modulate.a -= fade_speed * delta
		if tugas.modulate.a <= 0.0:
			tugas.modulate.a = 0.0
			fading_out = false  # Stop fading out

func start_fade_in():
	# Set up fade-in parameters
	fade_speed = 1.0 / fade_duration
	fading_in = true
	fading_out = false

func start_fade_out():
	# Set up fade-out parameters
	fade_speed = 1.0 / fade_duration
	fading_in = false
	fading_out = true
