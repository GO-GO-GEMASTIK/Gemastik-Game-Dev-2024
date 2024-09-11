extends Area2D


func _on_mouse_entered():
	$On.set_visible(true)


func _on_mouse_exited():
	$On.set_visible(false)
