class_name State
extends Node

@export var base_speed: float = 5.0

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")
var parent: Player

func enter() -> void:
	pass


func exit() -> void:
	pass


func state_process_unhandled_input(_event: InputEvent) -> State:
	return null


func state_process_input(_event: InputEvent) -> State:
	return null


func state_process_frame(_delta: float) -> State:
	return null


func state_process_physics(_delta: float)-> State:
	return null
