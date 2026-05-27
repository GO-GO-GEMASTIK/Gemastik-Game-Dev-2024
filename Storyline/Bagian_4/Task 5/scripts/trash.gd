extends Sprite2D

var dragging = false
var group := "dragable"

var x_pos
var y_pos


func _ready():
	z_index = ZIndexManager.set_index()


# DRAGGING MECHANISM
func _physics_process(delta):
	if !Input.is_action_pressed("click"):
		dragging = false
	rotation = lerp_angle(rotation, 0, 10 * delta)
	if dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		if _is_on_top():
			dragging = true
			z_index = ZIndexManager.get_newest_trash_z_index()
		
	if event.is_action_released("click"):
		dragging = false
# ====================

# UTILITY TO CHECK IF ITEM IS ON TOP
func _on_mouse_entered():
	add_to_group(group + "hovered")


func _on_mouse_exited():
	remove_from_group(group + "hovered")


func _is_on_top() -> bool:
	for dragable in get_tree().get_nodes_in_group(group + "hovered"):
		if dragable.z_index > z_index:
			return false
	return true
#======================================

