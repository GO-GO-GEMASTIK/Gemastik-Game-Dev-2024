extends RigidBody2D

signal enable_ucing_camera
signal disable_ucing_camera
signal move_friends
signal jump_maung
signal show_lari

@onready var box_camera: Camera2D = $Camera2D
@onready var task_icon = $TaskPlayer
@onready var pop = %Pop

var interactable := false
var walled := false

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "tembok":
		interactable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("talk") and interactable:
		move_friends.emit()
		disable_ucing_camera.emit()
		set_collision_layer_value(1, true)
		interactable = false
	if event.is_action_pressed("click"):
		jump_maung.emit()

func _on_push_area_body_entered(body):
	pop.play()
	task_icon.show_icon()

func _on_push_area_body_exited(body):
	task_icon.hide_icon()


func _on_wall_area_body_entered(body):
	if body.name == "MC" and !walled:
		show_lari.emit()
		enable_ucing_camera.emit()
		box_camera.set_enabled(false)
		walled = true
