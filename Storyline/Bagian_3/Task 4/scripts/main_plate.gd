extends Area2D

var nugget = 0
var ebi = 0
var milk = 0
var egg = 0

var has_emitted = false
var nugget_has_toggled = false
var ebi_has_toggled = false
var milk_has_toggled = false
var egg_has_toggled = false

@onready var nugget_done = $NuggetDone
@onready var ebi_done = $EbiDone
@onready var egg_done = $EggDone
@onready var milk_done = $MilkDone

@export var correct_sound: AudioStreamPlayer2D

signal done

func _ready():
	done.connect(owner._task_done)


func finish_check() -> bool:
	if nugget == 1 and ebi == 2 and milk == 1 and egg == 1:
		return true
	return false


func _process(delta):
	if finish_check() and not has_emitted:
		done.emit()
		has_emitted = true
	
	if nugget == 1:
		if !nugget_has_toggled:
			nugget_done.set_visible(true)
			correct_sound.play()
			nugget_has_toggled = true
	else:
		if nugget_has_toggled:
			nugget_done.set_visible(false)
			nugget_has_toggled = false
	
	if ebi == 2:
		if !ebi_has_toggled:
			ebi_done.set_visible(true)
			correct_sound.play()
			ebi_has_toggled = true
	else:
		if ebi_has_toggled:
			ebi_done.set_visible(false)
			ebi_has_toggled = false
	
	if milk == 1:
		if !milk_has_toggled:
			milk_done.set_visible(true)
			correct_sound.play()
			milk_has_toggled = true
	else:
		if milk_has_toggled:
			milk_done.set_visible(false)
			milk_has_toggled = false
	
	if egg == 1:
		if !egg_has_toggled:
			egg_done.set_visible(true)
			correct_sound.play()
			egg_has_toggled = true
	else:
		if egg_has_toggled:
			egg_done.set_visible(false)
			egg_has_toggled = false


func _on_area_entered(area):
	if area.name == "Nugget":
		nugget += 1
		print("NUGGET " + str(nugget))
	if area.name == "Ebi":
		ebi += 1
		print("EBI " + str(ebi))
	if area.name == "Milk":
		milk += 1
		print("MILK " + str(milk))
	if area.name == "Egg":
		egg += 1
		print("EGG " + str(egg))


func _on_area_exited(area):
	if area.name == "Nugget":
		nugget -= 1
		print("NUGGET " + str(nugget))
	if area.name == "Ebi":
		ebi -= 1
		print("EBI " + str(ebi))
	if area.name == "Milk":
		milk -= 1
		print("MILK " + str(milk))
	if area.name == "Egg":
		egg -= 1
		print("EGG " + str(egg))
