extends CollisionShape2D

@onready var other1 = $"../../Question_1"
@onready var other2 = $"../../Question_2"
@onready var other3 = $"../../Question_4"
@onready var base = $"../../TextureRect/BaseLight"
@onready var answer = $"../Answer3"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position_3 = get_global_mouse_position()
	var distance_to_mouse_3 = global_position.distance_to(mouse_position_3)
	#print("E: ",mouse_position_3)
	#print("F: ",distance_to_mouse_3)

func _input(event):
	# Check if the left mouse button is pressed
	var mouse_position_3 = get_global_mouse_position()
	var distance_to_mouse_3 = global_position.distance_to(mouse_position_3)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if distance_to_mouse_3 <= 100:
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
				
				
			
