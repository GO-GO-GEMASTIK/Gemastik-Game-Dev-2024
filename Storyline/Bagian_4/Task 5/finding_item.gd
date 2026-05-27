extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ZIndexManager.reset_z_index()
	print("INDEX RESET, INDEX = " + str(ZIndexManager.highest_z_index))
