extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Sensitivity for mouse movement. Can change in properties.
@export var mouse_sensitivity: float = 1

@onready var nodeRefs: Dictionary = {
	"head_path": $Head,
	"camera_path": $Head/Smoothing/Camera3D
}


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	move_player_controller(delta)

	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()


# Handle all input events (currently handles mouse movement pls fix)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouselook_player_controller(event)


func move_player_controller(delta: float):
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var camera_direction: Vector2 = input_direction.normalized().rotated(-nodeRefs["head_path"].rotation.y)
	if is_on_floor():
		velocity.x = lerp(velocity.x, camera_direction.x * SPEED, 1 * delta)
		velocity.z = lerp(velocity.z, camera_direction.y * SPEED, 1 * delta)
	move_and_slide()
	pass

func mouselook_player_controller(event: InputEventMouseMotion) -> void:
	nodeRefs["head_path"].rotation_degrees.x += (-event.relative.y * mouse_sensitivity)
	nodeRefs["head_path"].rotation_degrees.y += (-event.relative.x * mouse_sensitivity)
