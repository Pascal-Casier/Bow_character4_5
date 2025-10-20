extends Node3D

@onready var main_camera: PhantomCamera3D = $MainCamera

@export var mouse_sensitivity : float = 0.20

@export var min_pitch : float = -89.9
@export var max_pitch : float = 50.0

@export var min_yaw : float = 0.0
@export var max_yaw : float = 360.0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees : Vector3
		pcam_rotation_degrees = main_camera.get_third_person_rotation_degrees()
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
		main_camera.set_third_person_rotation_degrees(pcam_rotation_degrees)
