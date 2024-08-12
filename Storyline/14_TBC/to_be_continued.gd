extends Control

var task1 = load("res://Storyline/4_Task 1_Testing/box_drag_drop.tscn")
var task2 = load("res://Storyline/5_Task 2/math_class.tscn")
var task3 = load("res://Storyline/6_Task 3/laundry_drag_drop.tscn")
var task4 = load("res://Storyline/7_Task 4/food_making.tscn")
var task5 = load("res://Storyline/8_Task 5/finding_item.tscn")
var task6 = load("res://Storyline/9_Task 6/puzzle.tscn")
var task7 = load("res://Storyline/10_Task 7/lock_pick_1.tscn")
var task8 = load("res://Storyline/11_Task 8/senter_game_1.tscn")
var menu = load("res://Storyline/1_Main Menu/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task1)


func _on_button_2_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task2)


func _on_button_3_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task3)


func _on_button_4_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task4)


func _on_button_5_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task5)


func _on_button_6_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task6)


func _on_button_7_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task7)


func _on_button_8_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(task8)


func _on_menu_button_pressed():
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(menu)
