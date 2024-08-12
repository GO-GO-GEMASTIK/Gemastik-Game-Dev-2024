extends Node2D

var selected = false
var rest_point
var rest_nodes = []
@onready var box_bola = %BoxBola
@onready var box_boneka = %BoxBoneka
@onready var node = $".."
@onready var correct = %Correct
@onready var wrong = %Wrong

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("zone")
	var ball_index = get_index() - 2
	print(ball_index)
	if ball_index < rest_nodes.size():
		rest_point = rest_nodes[ball_index].global_position
	else:
		rest_point = rest_nodes[0].global_position
	#rest_point = rest_nodes[1].global_position

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true
		box_boneka.animation = "hover"
		z_index = node.get_new_highest_z_index()  # Set to a new highest z-index
		
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		look_at(get_global_mouse_position())
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)
		rotation = lerp_angle(rotation, 0, 10 * delta)
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			box_boneka.animation = "default"
			var shortest_dist = 100
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist:
					if child.is_in_group("box_boneka"):
						queue_free()
						node.increment_count()
						correct.play()
					elif child.is_in_group("box_ball") or child.is_in_group("box_buku"):
						wrong.play()


