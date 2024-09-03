extends Node2D

@onready var ucing = get_node("Layout/MC")
# Called when the node enters the scene tree for the first time.
func _ready():
	if ucing != null:
		ucing.disable_movement()
	else:
		print("Error: my_object is null")
	#ucing.disable_movement()
	
	Dialogic.start("B3_monolog_kamar") # Replace with function body.\
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	await Dialogic.timeline_ended
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
	ucing.enable_movement()
