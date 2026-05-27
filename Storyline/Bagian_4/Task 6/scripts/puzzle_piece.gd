extends Sprite2D

@export var rest_zone: Node2D
@export var drop_area: Area2D
@export var group_name: String

signal plus_one

var rest_zone_pos : Vector2
var drop_area_pos : Vector2

var dragging = false
var on_puzzle = false
var freeze = false
var shortest_dist := 100

var group := "dragable"

# Called when the node enters the scene tree for the first time.
func _ready():
	rest_zone_pos = rest_zone.global_position
	drop_area_pos = drop_area.global_position


func _physics_process(delta):
	if !Input.is_action_pressed("click"):
		dragging = false
	if dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		if !on_puzzle:
			global_position = lerp(global_position, rest_zone_pos, 10 * delta)

func _on_drag_area_input_event(viewport, event, shape_idx):
	if !freeze:
		if event.is_action_pressed("click"):
			if _is_on_top():
				dragging = true
				z_index = ZIndexManager.get_new_highest_z_index()
			
		if event.is_action_released("click"):
			dragging = false
			if on_puzzle:
				global_position = drop_area_pos
				plus_one.emit()
				freeze = true


#region UTILITY TO CHECK IF ITEM IS ON TOP
func _on_drag_area_mouse_entered():
	add_to_group(group + "hovered")


func _on_drag_area_mouse_exited():
	remove_from_group(group + "hovered")


func _is_on_top() -> bool:
	
	for dragable in get_tree().get_nodes_in_group(group + "hovered"):
		if dragable.get_index() > get_index():
			return false
	
	return true
#endregion =======================


#region CHECK IF IN CORRECT PUZZLE ZONE
func _on_drag_area_area_entered(area):
	if area.is_in_group(group_name):
		on_puzzle = true


func _on_drag_area_area_exited(area):
	if area.is_in_group(group_name):
		on_puzzle = false
#endregion =======================
