extends Area2D

@onready var answer = $"../Question_1/Answer1"
@onready var answer_fix = $"../Question_1/1AnswerBg"
@onready var answer2 = $"../Question_2/Answer2"
@onready var answer_fix2 = $"../Question_2/2AnswerBg"
@onready var answer3 = $"../Question_3/Answer3"
@onready var answer_fix3 = $"../Question_3/3AnswerBg"
@onready var answer4 = $"../Question_4/Answer4"
@onready var answer_fix4 = $"../Question_4/4AnswerBg"
@onready var base = $Base
@onready var berhasil = $Berhasil
@onready var salah = $Salah1
@onready var salah2 = $Salah2
@onready var salah3 = $Salah3
@onready var salah4 = $Salah4
@onready var finish = $"../Finish_Sound"

var collect = [0,0,0,0]

var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if collect[0] + collect[1] + collect[2] + collect[3] < 4:
				if answer.get_text() != '6':
					salah.visible = true
					collect[0] = 0
				else:
					salah.visible = false
					answer_fix.visible = true
					collect[0] = 1
					
				if answer2.get_text() != '5':
					salah2.visible = true
					collect[1] = 0
				else:
					salah2.visible = false
					answer_fix2.visible = true
					collect[1] = 1
				if answer3.get_text() != '8':
					salah3.visible = true
					collect[2] = 0
				else:
					salah3.visible = false
					answer_fix3.visible = true
					collect[2] = 1
				if answer4.get_text() != '2':
					salah4.visible = true
					collect[3] = 0
				else:
					salah4.visible = false
					answer_fix4.visible = true
					collect[3] = 1
			else:
				print(collect[0] + collect[1] + collect[2] + collect[3])
				print("Benar semua!")
				base.visible = true
				berhasil.visible = true
				finish.play()
				TransitionScreen.transition_between()
				await TransitionScreen.on_transition_finished
				get_tree().change_scene_to_packed(tbc)

