extends Node2D

@onready var player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_icon():
	player.play("show")
	player.queue("float")
	
func hide_icon():
	player.play("hide")
