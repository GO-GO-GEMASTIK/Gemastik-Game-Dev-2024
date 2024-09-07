extends Node

var dialogue_is_running := false

#region DIALOGUE DRIVER
func start(dialogue: String):
	dialogue_is_running = true
	Dialogic.start(dialogue)
	await Dialogic.timeline_ended
	dialogue_is_running = false

func stop():
	Dialogic.end_timeline()
	dialogue_is_running = false
#endregion ===========================
