extends CharacterBody3D

# States enumerator.
enum PlayerStates {WALKING, SPRINTING, CROUCHING,}

# Exported variables to change PlayerController attributes.
@export var mouse_sensitivity: float = 1.0
@export var base_speed: float = 5.0
@export var air_strafe_speed: float = 0.5
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.0
@export var double_jump_multiplier: float = 1.1
@export var accel: float = 10.0

# Internal properties for use inside PlayerController.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var able_to_double_jump := true
var current_state: int = PlayerStates.WALKING :
	set(new_state):
		current_state = new_state
	get:
		return current_state

# Dictionary of references to nodes in the Editor.
@onready var nodeRefs: Dictionary = {
	"head_path": $Head,
	"camera_path": $Head/Smoothing/Camera3D,
}


func _ready():
	pass


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_player_controller(delta)
	jump_handler()
	_debug_functions()


# Should handle all input events (currently handles mouse movement pls fix)
func _input(event):
	if event is InputEventMouseMotion:
		mouselook_player_controller(event)


# Moves PlayerController with the input directions, calculates the head direction based off of it,
# and then manipulates velocity by interpolating between the head_direction, base_speed, and accel variables.
func move_player_controller(delta: float):
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var head_direction: Vector2 = input_direction.normalized().rotated(-nodeRefs["head_path"].rotation.y)
	if is_on_floor():
		velocity.x = lerp(velocity.x, head_direction.x * base_speed, accel * delta)
		velocity.z = lerp(velocity.z, head_direction.y * base_speed, accel * delta)
	else:
		velocity.x = lerp(velocity.x, head_direction.x * air_strafe_speed, accel * delta)
		velocity.z = lerp(velocity.z, head_direction.y * air_strafe_speed, accel * delta)
		pass
	print("Velocity X is " + str(velocity.x), "\nVelocity Z is " + str(velocity.z) + "\n")
	print(input_direction, " and ", head_direction)
	move_and_slide()
	pass


# We move head_path instead of camera, so camera can have it's own individual rotations and animations.
func mouselook_player_controller(event: InputEventMouseMotion) -> void:
	nodeRefs["head_path"].rotation_degrees.x += (-event.relative.y * mouse_sensitivity)
	nodeRefs["head_path"].rotation_degrees.y += (-event.relative.x * mouse_sensitivity)


# Handles double jump by checking mid air if Player can double jump.
func jump_handler()-> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		able_to_double_jump = true
	if able_to_double_jump and Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		velocity.y = jump_velocity * double_jump_multiplier
		able_to_double_jump = false


# Debug Functions to Reset Viewing Angle | TODO: REMOVE THIS WHEN DONE!!!!
func _debug_functions()-> void:
	if Input.is_action_just_pressed("ui_left"):
		nodeRefs["head_path"].rotation_degrees.y += 90
	elif Input.is_action_just_pressed("ui_right"):
		nodeRefs["head_path"].rotation_degrees.y -= 90
	elif Input.is_action_just_pressed("ui_down"):
		nodeRefs["head_path"].rotation_degrees.y = 0
