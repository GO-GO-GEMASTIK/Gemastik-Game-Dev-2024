extends Area2D

signal start_task

@export var ucing: CharacterBody2D

@onready var color_rect = %ColorRect
@onready var animation_player = %AnimationPlayer
@onready var box = $AnimatedSprite2D
@onready var task_warning = %TaskWarning
@onready var buba = %Buba
@onready var canvas_layer = %CanvasLayer

var camera: Camera2D
var animation_played = false
@onready var task_1 := GameStateManager.is_task_completed(1)

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if ucing and ucing.has_node("Camera2D"):
		camera = ucing.get_node("Camera2D")


func _on_dialogic_signal(argument:String):
	if argument == "pan_to_buba":
		buba.set_visible(true)
		camera.position = Vector2(1000,0)
	if argument == "fade_pan_ucing":
		color_rect.visible = true
		animation_player.play("fade_to_black")


#region Buba first encounter with Ucing
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		camera.position = Vector2(0,0)
		await get_tree().create_timer(1.0).timeout
		buba.set_global_position(Vector2(1000, 805))
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
# ---
func _on_body_entered(body):
	if body.name == "MC" and !animation_played and !GameStateManager.is_task_completed(1):
		ucing.disable_movement()
		box.play("dropped")
		Dialogic.start("box_jatuh")
		animation_played = true
# ---
func _on_animation_finished():
	if Dialogic.current_timeline:
		await Dialogic.timeline_ended
	task_warning.set_visible(true)
# ---
func _on_button_pressed():
	task_warning.set_visible(false)
	start_task.emit()
#endregion
