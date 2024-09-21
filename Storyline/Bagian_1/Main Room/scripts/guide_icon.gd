extends Area2D

signal l2b
signal b2r
signal r2b
signal b2l
signal r_out
signal r_in
signal l_out
signal l_in
signal go_outside

@export var ucing: CharacterBody2D
@export var icon_export: AnimationPlayer
@export var guide_player: AnimationPlayer
@onready var icon_player = $IconPlayer

@export var direction_kelas: bool = GameStateManager.get_string_state("DirectionKelas")
@export var direction_hutan: bool = GameStateManager.get_string_state("DirectionHutan")
@export var direction_laundry: bool = GameStateManager.get_string_state("DirectionLaundry")
@export var direction_kantin: bool = GameStateManager.get_string_state("DirectionKantin")

var upper_room = load("res://Storyline/Bagian_1/Main Room/main_room_upper.tscn")
var lower_room = load("res://Storyline/Bagian_1/Main Room/main_room_lower.tscn")
var main_room = load("res://Storyline/Bagian_1/Main Room/main_room.tscn")
var outside = load("res://Storyline/Bagian_4/BelakangSekolah/belakang_sekolah.tscn")
var kelas = load("res://Storyline/Bagian_2/Kelas/kelas.tscn")
var laundry = load("res://Storyline/Bagian_3/Laundry/laundry.tscn")
var kantin = load("res://Storyline/Bagian_3/Kantin/kantin.tscn")

var change_scene_upper = false
var change_scene_lower = false
var change_scene_main = false
var change_scene_outside = false
var change_scene_kelas = false
var change_scene_laundry = false
var change_scene_kantin = false

# TIMELINE CHECK
var bagian_2 = GameStateManager.get_string_state("Bagian2")
var bagian_3 = GameStateManager.get_string_state("Bagian3")
var bagian_4 = GameStateManager.get_string_state("Bagian4")

var owner_upper = false

func _ready():
	if owner.name == "UpperRoom":
		owner_upper = true

func _on_body_entered(body):
	if body.name == "MC":
		$PopSound.play()
		icon_player.play("fade_in")
		icon_player.queue("float_loop")
		
		if name == "IconNaik":
			change_scene_upper = true
		elif name == "IconTurun":
			change_scene_lower = true
		elif name == "IconToMain":
			change_scene_main = true
			if direction_hutan and owner_upper:
				if global_position.x < ucing.global_position.x:
					l2b.emit()
				else:
					r2b.emit()

		elif name == "PintuKeluar":
			change_scene_outside = true
			if bagian_4 or direction_hutan:
				r_out.emit()
		elif name == "PintuKelas":
			change_scene_kelas = true
			if direction_kelas:
				guide_player.play("hide_guide_kelas")
		elif name == "PintuLaundry":
			change_scene_laundry = true
			if direction_laundry:
				guide_player.play("hide_laundry")
		elif name == "PintuKantin":
			change_scene_kantin = true
			if direction_kantin:
				guide_player.play("hide_kantin")


func _on_body_exited(body):
	if body.name == "MC":
		Dialogic.end_timeline()
		icon_player.play("fade_out")
		
		if name == "IconNaik":
			change_scene_upper = false
		elif name == "IconTurun":
			change_scene_lower = false
		elif name == "IconToMain":
			change_scene_main = false
			if direction_hutan and owner_upper:
				if global_position.x < ucing.global_position.x:
					b2l.emit()
				else:
					b2r.emit()
			
		elif name == "PintuKeluar":
			change_scene_outside = false
			if bagian_4 or direction_hutan:
				r_in.emit()
		elif name == "PintuKelas":
			change_scene_kelas = false
			if direction_kelas:
				guide_player.play("show_guide_kelas")
		elif name == "PintuLaundry":
			change_scene_laundry = false
			if direction_laundry:
				guide_player.play("show_laundry")
		elif name == "PintuKantin":
			change_scene_kantin = false
			if direction_kantin:
				guide_player.play("show_kantin")


func _input(event):
	if event.is_action_pressed("talk"):
		if change_scene_upper:
			GameStateManager.update_pos_main(ucing.global_position)
			if GameStateManager.get_string_state("GuidePintuKuning"):
				guide_player.play("hide_guide_pintu")
			change_scene(upper_room)
		elif change_scene_lower:
			GameStateManager.update_pos_main(ucing.global_position)
			if GameStateManager.get_string_state("GuidePintuKuning"):
				guide_player.play("hide_guide_pintu")
			change_scene(lower_room)
		elif change_scene_main:
			if direction_kelas and owner_upper:
				guide_player.play("hide_guide_kelas")
			if GameStateManager.get_string_state("GuidePintuKuning"):
				guide_player.play("hide_guide_pintu")
			GameStateManager.set_pos_state("TanggaMain", true)
			change_scene(main_room)
		elif change_scene_outside:
			if direction_hutan:
				GameStateManager.set_string_state("DirectionHutan", false)
				change_scene(outside)
			else:
				Dialogic.start("unable_door")
				await Dialogic.timeline_ended
		elif change_scene_kelas:
			if direction_kelas:
				GameStateManager.update_pos_main(ucing.global_position)
				GameStateManager.set_string_state("DirectionKelas", false)
				change_scene(kelas)
			else:
				Dialogic.start("wrong_door")
				await Dialogic.timeline_ended
		elif change_scene_laundry:
			if direction_laundry:
				GameStateManager.update_pos_main(ucing.global_position)
				GameStateManager.set_string_state("DirectionLaundry", false)
				change_scene(laundry)
			else:
				Dialogic.start("wrong_door")
				await Dialogic.timeline_ended
		elif change_scene_kantin:
			if direction_kantin:
				GameStateManager.update_pos_main(ucing.global_position)
				GameStateManager.set_string_state("DirectionKantin", false)
				change_scene(kantin)
			else:
				Dialogic.start("wrong_door")
				await Dialogic.timeline_ended

func change_scene(scene: PackedScene):
	TransitionScreen.transition_loading()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(scene)
