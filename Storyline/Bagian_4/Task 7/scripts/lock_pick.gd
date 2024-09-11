extends Node2D

@export var scene: PackedScene
@export var correct_kunci: Sprite2D

@export var finish_sound: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	correct_kunci.next_scene.connect(change_scene)


func change_scene():
	if finish_sound:
		finish_sound.play()
	if scene:
		GameStateManager.complete_task(7)
		await get_tree().create_timer(1.0).timeout
		TransitionScreen.transition_between()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(scene)
	else:
		print("No Scene Available")
