extends Sprite2D

@export var hoveredSprite: Sprite2D
@export var wrongSprite: Sprite2D
@export var correctSprite: Sprite2D

@onready var correct = %Correct
@onready var wrong = %Wrong

signal next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_mouse_entered():
	hoveredSprite.set_visible(true)


func _on_area_2d_mouse_exited():
	hoveredSprite.set_visible(false)


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		if is_in_group("correct_key"):
			correct.play()
			correctSprite.set_visible(true)
			next_scene.emit()
		else:
			wrong.play()
			wrongSprite.set_visible(true)
