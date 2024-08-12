extends AnimatedSprite2D

var flag = 0
@onready var correct = %Correct
@onready var wrong = %Wrong
@onready var finish = %Finish
@onready var nyala = %Nyala
@onready var senter = %Senter_On

var tapme = [KEY_G, KEY_O,KEY_T, KEY_O, KEY_N, KEY_G,KEY_R, KEY_O,KEY_Y, KEY_O, KEY_N, KEY_G]
var animate = ['1', '2', '3', '4', '5', '6','7','8','9','10','11','12']
var finished = false

var tbc = load("res://Storyline/14_TBC/to_be_continued.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = 'default'  


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if flag < 12: 
		if Input.is_anything_pressed():
			if Input.is_key_pressed(tapme[flag]):
				self.animation = animate[flag]  # Update animatio
				correct.play()
				print(tapme[flag])
				flag+=1
			else:
				wrong.play()
				print("Mumun")
	elif flag >= 12 && !finished:
		finish.play()
		finished = true
		nyala.visible = true
		Dialogic.start("senter_nyala")
		Dialogic.signal_event.connect(DialogicSignal)
		await Dialogic.timeline_ended
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(tbc)
		
	
func DialogicSignal(argument:String):
	if argument == "On":
		senter.visible = true
		senter.animation = "kelap_kelip"
	if argument == "Go":
		senter.animation = "nyala_full"
	

