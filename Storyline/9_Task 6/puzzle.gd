extends Node2D

@onready var warning_screen = $WarningScreen
@onready var warning_fade_out = $WarningScreen/AnimationPlayer
@onready var finished_puzzle = $FinishedPuzzle
@onready var finish = $Finish
@onready var correct = $Correct

var placed_puzzle := 0

var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1.0).timeout
	warning_fade_out.play("fade_out")
	

func _on_plus_one():
	placed_puzzle += 1
	if placed_puzzle == 5:
		task_finished()
	else:
		correct.play()

func task_finished():
	finished_puzzle.set_visible(true)
	finish.play()
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(tbc)
