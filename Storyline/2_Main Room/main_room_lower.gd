extends Node2D

@onready var guide_player = $CanvasLayer/GuidePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameStateManager.get_string_state("GuidePintuKuning"):
		guide_player.play("show_guide_pintu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
