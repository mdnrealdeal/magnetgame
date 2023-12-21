extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mousecapture_exit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("mousecapture_enter"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
