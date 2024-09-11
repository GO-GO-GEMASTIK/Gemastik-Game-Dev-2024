extends Area2D

@onready var hint = $Sprite2D

func _on_mouse_entered():
	hint.set_visible(true)


func _on_mouse_exited():
	hint.set_visible(false)
