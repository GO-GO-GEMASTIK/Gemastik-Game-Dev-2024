extends TextureRect

@onready var is_jujur := GameStateManager.get_characteristic("Jujur")
@onready var is_kerja_sama := GameStateManager.get_characteristic("KerjaSama")
@onready var is_menghargai := GameStateManager.get_characteristic("Menghargai")

@onready var jujur = %Jujur
@onready var bekerja_sama = %BekerjaSama
@onready var menghargai = %Menghargai

# Called when the node enters the scene tree for the first time.
func _ready():
	recheck_and_update_visibility()

# Function to re-check conditions and update visibility
func recheck_and_update_visibility():
	is_jujur = GameStateManager.get_characteristic("Jujur")
	is_kerja_sama = GameStateManager.get_characteristic("KerjaSama")
	is_menghargai = GameStateManager.get_characteristic("Menghargai")
	
	jujur.set_visible(is_jujur)
	bekerja_sama.set_visible(is_kerja_sama)
	menghargai.set_visible(is_menghargai)
