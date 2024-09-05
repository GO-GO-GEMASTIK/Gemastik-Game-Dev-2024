extends Node2D

@onready var kerjasama = GameStateManager.get_naughty_nice("Kerjasama")
@onready var kejujuran = GameStateManager.get_naughty_nice("Kejujuran")
@onready var rendah_hati = GameStateManager.get_naughty_nice("Rendah Hati")
@onready var poin_kerjasama = $MapLayout/Kerjasama
@onready var poin_kejujuran = $MapLayout/Kejujuran
@onready var poin_rendah_hati = $MapLayout/Rendah_Hati

var kamar = load("res://Storyline/17_Bagian_3/kamar_bagian_3.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start("B2_Papan")
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	if kejujuran == 1:
		poin_kejujuran.animation = "1"
	elif kejujuran == 0:
		poin_kejujuran.animation = "0"
	else:
		poin_kejujuran.animation = "0"
	if kerjasama == 1:
		poin_kerjasama.animation = "1"
	elif kerjasama == 0:
		poin_kerjasama.animation = "0"
	else:
		poin_kerjasama.animation = "0"
	if rendah_hati == 1:
		poin_rendah_hati.animation = "1"
	elif rendah_hati == 0:
		poin_rendah_hati.animation = "0"
	else:
		poin_rendah_hati.animation = "0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialog_ended():
	Dialogic.timeline_ended.disconnect(_on_dialog_ended)
	TransitionScreen.transition_between()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(kamar)
