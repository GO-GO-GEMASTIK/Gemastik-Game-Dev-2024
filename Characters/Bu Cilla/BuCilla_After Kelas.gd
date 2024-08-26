extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start dialog
	Dialogic.start("dialog_kelas_after")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	
	 

func _on_dialogic_signal(argument:String):
	if argument == "load":
		Dialogic.timeline_ended.connect(_on_dialog_ended)
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		Dialogic.start("dialog_kelas_after_2")
		Dialogic.timeline_ended.connect(_on_dialog_ended)
		
		
func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
