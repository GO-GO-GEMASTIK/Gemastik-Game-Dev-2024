extends Node

var ucing_pos_main := Vector2(300.0, 600.0)

var tasks := {
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
	7: false,
	8: false
}

var naughty_nice := {
	"Kejujuran": "None",
	"Rendah Hati": "None",
	"Kerjasama": "None"
}

var string_states := {
	"Gudang": false,
	"Kantin": false,
	"Laundry": false,
	"GuidePintuKuning": false,
	"KeluarKamar": false,
}

var right_limit := {
	"lantai_dasar": 8295,
	"lantai_atas": 1000,
	"lantai_bawah": 1000,
	"gudang": 1000,
	"kamar": 3000,
	"kelas": 1000,
	"kantin": 1000,
	"laundry": 1000,
	"belakang_sekolah": 11000,
	"bukit": 9000,
}

# State methods
func set_naughty_nice(behavior: String, state: String):
	if behavior in naughty_nice:
		naughty_nice[behavior] = state

func get_naughty_nice(behavior: String) -> int:
	if naughty_nice[behavior] == "1":
		print(naughty_nice[behavior])
		return int(naughty_nice.get(behavior, 1))
	else:
		print(naughty_nice[behavior])
		return int(naughty_nice.get(behavior,0))

func update_pos_main(newPos: Vector2):
	newPos.x -= 200
	ucing_pos_main = newPos
	return ucing_pos_main

func get_pos_main() -> Vector2:
	return ucing_pos_main
#endregion

#region Task-related State Methods
func complete_task(task_number: int):
	if task_number in tasks:
		tasks[task_number] = true

func reset_task(task_number: int):
	if task_number in tasks:
		tasks[task_number] = false

func is_task_completed(task_number: int) -> bool:
	return tasks.get(task_number, false)
#endregion


#region General State methods
func set_string_state(room: String, state: bool):
	if room in string_states:
		string_states[room] = state

func get_string_state(room: String) -> bool:
	return string_states.get(room, false)

func add_new_state(room: String):
	if room not in string_states:
		string_states[room] = false
#endregion


#region Room Limit Methods
func get_room_right_limit(room: String):
	if room in right_limit:
		return right_limit[room]
#endregion
