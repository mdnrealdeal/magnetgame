class_name StateMachine
extends Node

@export var starting_state: State

var current_state: State

func init(new_parent: Player) -> void:
	for child: State in get_children():
		child.parent = new_parent

	change_state(starting_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


func manager_process_physics(delta: float) -> void:
	var new_state: State = current_state.state_process_physics(delta)
	if new_state:
		change_state(new_state)


func manager_process_input(event: InputEvent) -> void:
	var new_state: State = current_state.state_process_input(event)
	if new_state:
		change_state(new_state)


func manager_process_unhandled_input(event: InputEvent) -> void:
	var new_state: State = current_state.state_process_unhandled_input(event)
	if new_state:
		change_state(new_state)


func manager_process_frame(delta: float) -> void:
	var new_state: State = current_state.state_process_frame(delta)
	if new_state:
		change_state(new_state)



