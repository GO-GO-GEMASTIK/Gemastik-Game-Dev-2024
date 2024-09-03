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

var string_states := {
	"Gudang": false,
	"Kantin": false,
	"Laundry": false,
	"GuidePintuKuning": false,
}

func update_pos_main(newPos: Vector2):
	newPos.x -= 200
	ucing_pos_main = newPos
	return ucing_pos_main

func get_pos_main() -> Vector2:
	return ucing_pos_main

#region Task-related Methods
func complete_task(task_number: int):
	if task_number in tasks:
		tasks[task_number] = true

func reset_task(task_number: int):
	if task_number in tasks:
		tasks[task_number] = false

func is_task_completed(task_number: int) -> bool:
	return tasks.get(task_number, false)
#endregion


# State methods
func set_string_state(room: String, state: bool):
	if room in string_states:
		string_states[room] = state

func get_string_state(room: String) -> bool:
	return string_states.get(room, false)

func add_new_state(room: String):
	if room not in string_states:
		string_states[room] = false
