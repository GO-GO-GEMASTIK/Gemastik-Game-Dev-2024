extends CollisionShape2D

@onready var other1 = $"../../Question_1"
@onready var other2 = $"../../Question_3"
@onready var other3 = $"../../Question_4"
@onready var base = $"../../TextureRect/BaseLight"
@onready var answer = $"../Answer2"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var distance_to_mouse = global_position.distance_to(mouse_position)
	#print("C: ",mouse_position)
	#print("D: ",distance_to_mouse)

func _input(event):
	# Check if the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if global_position.distance_to(get_global_mouse_position()) <= 100:
				other1.visible = false
				other2.visible = false
				other3.visible = false
				answer.visible = true
				base.visible = true
			else:
				other1.visible = true
				other2.visible = true
				other3.visible = true
				answer.visible = false
				base.visible = false
				
			
