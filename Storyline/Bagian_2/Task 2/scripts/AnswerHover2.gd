extends LineEdit

@onready var other1 = $"../../Question_1"
@onready var other2 = $"../../Question_3"
@onready var other3 = $"../../Question_4"
@onready var base = $"../../TextureRect/BaseLight"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	self.modulate.a = 0.9
	other1.visible = false
	other2.visible = false
	other3.visible = false
	base.visible = true



func _on_mouse_exited():
	self.modulate.a = 0.9
	other1.visible = true
	other2.visible = true
	other3.visible = true
	base.visible = false


func _on_gui_input(event):
	pass
