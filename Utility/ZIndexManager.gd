extends Node

var highest_z_index = 30

var trash_index = 0

func get_new_highest_z_index():
	highest_z_index += 1
	return highest_z_index

func reset_z_index():
	highest_z_index = 0

func set_index() -> int:
	trash_index += 1
	return trash_index

func get_newest_trash_z_index() -> int:
	trash_index += 1
	return trash_index
