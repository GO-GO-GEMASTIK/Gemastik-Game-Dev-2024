extends Button

@onready var on = $On

var pause := false
static var menu := false


func _process(delta):
	if !menu and name != "PauseButton":
		disabled = true
		on.set_visible(false)
	else:
		disabled = false

static func menu_open():
	menu = true

static func menu_close():
	menu = false

# HANDLE MOUSE ENTERING
func _on_mouse_entered():
	if name == "PauseButton":
		pause = true
		on.set_visible(true)
	elif menu:
		on.set_visible(true)

func _on_mouse_exited():
	if name == "PauseButton":
		pause = false
		on.set_visible(false)
	elif menu:
		on.set_visible(false)


# PAUSE BUTTON AESTHETICS
func _physics_process(delta):
	if Input.is_action_pressed("click"):
		if pause and on:
			on.set_visible(false)
	else:
		if pause and on:
			on.set_visible(true)
