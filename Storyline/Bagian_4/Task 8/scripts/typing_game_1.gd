extends AnimatedSprite2D

var flag = 0
@onready var correct = %Correct
@onready var wrong = %Wrong
@onready var finish = %Finish
@onready var nyala = %Nyala

var tapme = [KEY_D, KEY_A, KEY_D, KEY_U]
var animate = ['1', '2', '3', '4']
var finished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if flag < 4: 
		if Input.is_anything_pressed():
			if Input.is_key_pressed(tapme[flag]):
				self.animation = animate[flag]  # Update animatio
				correct.play()
				print(tapme[flag])
				flag+=1
			else:
				wrong.play()
				print("Mumun")
	elif flag == 4 && !finished:
		finish.play()
		finished = true
		nyala.visible = true
		flag+=1
	elif flag == 5 && Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://Storyline/Bagian_4/Task 8/senter_game_2.tscn")
	
