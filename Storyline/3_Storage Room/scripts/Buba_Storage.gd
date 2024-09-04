extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogic_signal(argument:String):
	if argument == "1":
		print("Baik")
		GameStateManager.set_naughty_nice("Rendah Hati","1")
		GameStateManager.get_naughty_nice("Rendah Hati")
	elif argument == "0":
		print("Ga baik")
		GameStateManager.set_naughty_nice("Rendah Hati","0")
		GameStateManager.get_naughty_nice("Rendah Hati")
	else:
		print("Ndak masuk")
