extends Node2D

@onready var ucing = get_node("MapLayout/MC")
@onready var maung = get_node("MapLayout/Maung")
# Called when the node enters the scene tree for the first time.
func _ready():
	ucing.disable_movement()
	Dialogic.start("B3_dialog_kelas") # Replace with function body.\
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	await Dialogic.timeline_ended
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if ucing.global_position.x - maung.global_position.x < 300:
			#ucing.disable_movement()
			#Dialogic.start("B3_dialog_kelas") # Replace with function body.\
			#Dialogic.timeline_ended.connect(_on_dialog_ended)
			#await Dialogic.timeline_ended
	

func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
	ucing.enable_movement()
