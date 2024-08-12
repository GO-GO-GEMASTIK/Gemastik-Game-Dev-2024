extends Node2D

var nugget = preload("res://Storyline/7_Task 4/subscenes/nugget.tscn")
var ebi = preload("res://Storyline/7_Task 4/subscenes/ebi.tscn")
var milk = preload("res://Storyline/7_Task 4/subscenes/milk.tscn")
var egg = preload("res://Storyline/7_Task 4/subscenes/egg.tscn")

var is_dragged = false
var on_plate = false
var object_instantiated = false
var current: Sprite2D

var highest_z_index: int = 5

@export var finish_sound: AudioStreamPlayer2D

var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

# DUPLICATION CHECK
func _process(_delta):
	if Input.is_action_just_released("click"):
		object_instantiated = false

# DRAGGING
func _physics_process(delta):
	if is_dragged:
		current.global_position = lerp(current.global_position, get_global_mouse_position(), 25 * delta)
		current.look_at(get_global_mouse_position())

# DRAG RELEASED
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if on_plate:
				if current:
					current.global_position = get_global_mouse_position()
					is_dragged = false
					current = null
					on_plate = false
			else:
				if current:
					current.queue_free()
					is_dragged = false
					current = null
# =====================================

# INSTANTIATE DRIVER
func inst(food: Sprite2D):
	is_dragged = true
	current = food
	current.position = get_global_mouse_position()
	current.z_index = ZIndexManager.get_new_highest_z_index()
	add_child(current)
	object_instantiated = true
# ====================

# MAIN PLATE
func _on_main_plate_area_entered(_area):
	on_plate = true


func _on_main_plate_area_exited(_area):
	on_plate = false
# ============

# INSTANTIATE -> NUGGET - EGG - MILK - EBI
func _on_plate_nugget_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") and not object_instantiated:
		inst(nugget.instantiate())


func _on_plate_egg_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") and not object_instantiated:
		inst(egg.instantiate())


func _on_plate_milk_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") and not object_instantiated:
		inst(milk.instantiate())


func _on_plate_ebi_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") and not object_instantiated:
		inst(ebi.instantiate())
# ============================================

func _task_done():
	finish_sound.play()
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(tbc)


func get_new_highest_z_index():
	highest_z_index += 1
	return highest_z_index
