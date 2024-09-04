extends Node2D

signal following
signal r_in
signal r_out

@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera

var hutan := false

# Called when the node enters the scene tree for the first time.
func _ready():
	following.emit()
	camera.set_limit(SIDE_RIGHT, GameStateManager.get_room_right_limit("bukit"))
	camera.set_limit(SIDE_BOTTOM, 2698)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_next_area_body_entered(body):
	hutan = true
	r_in.emit()

func _on_next_area_body_exited(body):
	hutan = false
	r_out.emit()


func _on_hutan_area_body_entered(body):
	pass # Replace with function body.
