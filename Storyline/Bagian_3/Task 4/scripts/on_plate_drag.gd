extends Sprite2D

var dragging = false
var on_plate = false

var group := "dragable"

func _physics_process(delta):
	rotation = lerp_angle(rotation, 0, 10 * delta)
	if dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		look_at(get_global_mouse_position())


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		if _is_on_top():
			if on_plate:
				dragging = true
				z_index = ZIndexManager.get_new_highest_z_index()
		
	if event.is_action_released("click"):
		if !on_plate:
			queue_free()
			dragging = false
		else:
			#position = get_global_mouse_position()
			dragging = false


func _on_area_2d_area_entered(area):
	if area.name == "MainPlate":
		on_plate = true


func _on_area_2d_area_exited(area):
	if area.name == "MainPlate":
		on_plate = false

# UTILITY TO CHECK IF ITEM IS ON TOP
func _on_mouse_entered():
	add_to_group(group + "hovered")


func _on_mouse_exited():
	remove_from_group(group + "hovered")


func _is_on_top() -> bool:
	
	for dragable in get_tree().get_nodes_in_group(group + "hovered"):
		if dragable.get_index() > get_index():
			return false
	
	return true
#======================================
