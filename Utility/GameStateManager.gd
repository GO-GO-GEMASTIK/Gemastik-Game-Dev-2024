extends Node

var ucing_pos_main := Vector2(800.0, 628.0)

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

var free_roam_states := {
	"Gudang": false,
	"Kantin": false,
	"Laundry": false
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


# Free roam state methods
func set_free_roam_state(room: String, state: bool):
	if room in free_roam_states:
		free_roam_states[room] = state

func get_free_roam_state(room: String) -> bool:
	return free_roam_states.get(room, false)

func add_new_room(room: String):
	if room not in free_roam_states:
		free_roam_states[room] = false
