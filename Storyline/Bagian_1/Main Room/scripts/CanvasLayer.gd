extends CanvasLayer

@export var tutor_1: Texture
@export var tutor_2: Texture
@export var tutor_3: Texture
@export var tutor_4: Texture

@onready var tutorial = $TutorialPlayer/Tutorial
@onready var tutorial_player = $TutorialPlayer

var tutor_1_showed = false
var tutor_2_showed = false
var tutor_3_showed = false
var tutor_4_showed = false

var passed_1 = false
var passed_2 = false
var passed_3 = false
var passed_4 = false

@onready var task_check = GameStateManager.any_task_true()
@onready var tutorial_done = GameStateManager.get_string_state("TutorialDone")

# ======DEBUGGING ONLY!!!======
@export var debug: bool = false
# ======DEBUGGING ONLY!!!======

# Called when the node enters the scene tree for the first time.
func _ready():
	if !task_check and !tutorial_done and !debug:
		await get_tree().create_timer(1).timeout
		tutorial.set_texture(tutor_1)
		tutorial_player.play("show_tutorial")
		tutor_1_showed = true


func _on_area_papan_body_entered(body):
	if tutor_1_showed and not passed_1:
		hide_show_tutor(tutor_2)
		tutor_2_showed = true
		passed_1 = true

func _input(event):
	if event.is_action_pressed("jump") and tutor_2_showed and !passed_2:
		tutor_3_showed = true
		hide_show_tutor(tutor_3)
		passed_2 = true
	if event.is_action_pressed("talk") and tutor_3_showed and !passed_3:
		tutor_4_showed = true
		hide_show_tutor(tutor_4)
		passed_3 = true
	if event.is_action_pressed("click") and tutor_4_showed and !passed_4:
		tutorial_player.play("hide_tutorial")
		passed_4 = true
		GameStateManager.set_string_state("TutorialDone", true)


func hide_show_tutor(tutor):
	tutorial_player.play("hide_tutorial")
	await get_tree().create_timer(1).timeout
	tutorial.set_texture(tutor)
	tutorial_player.play("show_tutorial")
