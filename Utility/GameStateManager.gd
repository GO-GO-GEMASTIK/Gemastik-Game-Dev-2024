extends Node

var ucing_pos_main := Vector2(800.0, 628.0)


func update_pos_main(newPos: Vector2):
	newPos.x -= 200
	ucing_pos_main = newPos
	return ucing_pos_main

func get_pos_main() -> Vector2:
	return ucing_pos_main
