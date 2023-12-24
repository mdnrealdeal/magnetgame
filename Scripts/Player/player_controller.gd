class_name Player
extends CharacterBody3D

@onready var movement_machine: StateMachine = $Machines/MovementMachine
@onready var interaction_machine: StateMachine = $Machines/InteractionsMachine


func _ready() -> void:
	movement_machine.init(self)
	pass


func _unhandled_input(event: InputEvent) -> void:
	movement_machine.manager_process_unhandled_input(event)


func _input(event: InputEvent) -> void:
	movement_machine.manager_process_input(event)


func _physics_process(delta: float) -> void:
	movement_machine.manager_process_physics(delta)


func _process(delta: float) -> void:
	movement_machine.manager_process_frame(delta)
