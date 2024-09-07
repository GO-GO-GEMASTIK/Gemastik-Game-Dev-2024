extends Node2D

@onready var guide_player = $CanvasLayer/GuidePlayer
@onready var ucing = $MC
@onready var camera: Camera2D = ucing.camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.set_limit(SIDE_RIGHT, GameStateManager.get_room_right_limit("lantai_bawah"))
	if GameStateManager.get_string_state("GuidePintuKuning"):
		guide_player.play("show_guide_pintu")

