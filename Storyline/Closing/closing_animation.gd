extends Node2D

@onready var perfect = $CanvasLayer/Perfect
@onready var imperfect = $CanvasLayer/Imperfect
@onready var animation = $CanvasLayer/AnimationPlayer
@onready var credit = $CanvasLayer/Credit

var main_menu = load("res://Storyline/Main Menu/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameStateManager.count_true() >= 3:
		perfect.play()
		print("PREFTCT")
		await perfect.finished
		credit.set_visible(true)
		animation.play("credit")
		await animation.animation_finished
	else:
		imperfect.play()
		print("NOTTT")
		await imperfect.finished
		credit.set_visible(true)
		animation.play("credit")
		await animation.animation_finished
	
	#GameStateManager.set_string_state("TBC", true)
	
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(main_menu)
