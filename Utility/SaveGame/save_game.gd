extends CanvasLayer

signal menu_open
signal menu_close

@export var ucing : CharacterBody2D
@export var buba : CharacterBody2D
@export var maung : CharacterBody2D
@export var otan : CharacterBody2D
@export var cula : CharacterBody2D

@onready var menus = $Menus

const buttons = preload("res://Utility/SaveGame/scripts/button.gd")
var main_menu = load("res://Storyline/Main Menu/main_menu.tscn")

func _on_pause_button_button_down():
	if ucing:
		ucing.disable_movement()
	menus.set_visible(true)
	buttons.menu_open()


func _on_lanjutkan_button_button_down():
	if ucing:
		ucing.enable_movement()
	menus.set_visible(false)
	buttons.menu_close()


func _on_simpan_button_button_down():
	var save_data = SaveData.new()
	# Assign the current game state
	save_data.string_states = GameStateManager.get_string_states()
	save_data.tasks = GameStateManager.get_tasks()
	save_data.characteristics = GameStateManager.get_characteristics()
	save_data.current_scene_path = get_tree().current_scene.scene_file_path
	if ucing:
		save_data.ucing_pos = GameStateManager.get_pos_main()
	if buba:
		save_data.ucing_pos = buba.get_global_position()
	if maung:
		save_data.ucing_pos = maung.get_global_position()
	
	# Save the resource to a file
	var save_path = "user://savegame.tres"  # Use .res for binary
	var error = ResourceSaver.save(save_data, save_path)
	
	if error == OK:
		print("Game saved successfully.")
	else:
		print("Error saving game: %s" % error)
	

func _on_keluar_button_button_down():
	menus.set_visible(false)
	buttons.menu_close()
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(main_menu)

