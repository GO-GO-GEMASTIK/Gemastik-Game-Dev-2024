extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var loading = $CanvasLayer/Loading


func _ready():
	color_rect.visible = false
	#animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_black_to_loading":
		on_transition_finished.emit()
		
		loading.set_visible(true)
		loading.play("loading")
		await get_tree().create_timer(1.0).timeout
		loading.set_visible(false)
		
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false

# Pilih salah satu method di bawah untuk transisi
# Transisi antara 2 scene (Panggil method di scene sebelumnya)
func transition_between():
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
# Transisi masuk pada 1 scene (Panggil method di scene setelahnya)
func transition_in():
	color_rect.visible = true
	animation_player.play("fade_to_normal")

func transition_loading():
	color_rect.visible = true
	animation_player.play("fade_to_black_to_loading")

