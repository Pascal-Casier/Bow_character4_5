extends Node3D

@onready var main_camera: PhantomCamera3D = $MainCamera

enum camera_states {
	WALK, RUN, ACTIVE, FIRE
}

var pos : Vector3
var spring_arm : float
var fov : int
var hoffset : float
var voffset : float
var current_state = null

@onready var cam_transition_speed : float = 2.0


@export var mouse_sensitivity : float = 0.20

@export var min_pitch : float = -89.9
@export var max_pitch : float = 50.0

@export var min_yaw : float = 0.0
@export var max_yaw : float = 360.0

func set_camera_position_value(to_state : camera_states):
	match to_state:
		camera_states.WALK:
			current_state = camera_states.WALK
			pos = Vector3(0.0, 1.5, 0.0)
			spring_arm = 1.85
			fov = 75
			hoffset = 0.0
			voffset = 0.0
			min_pitch = -90
			max_pitch = 50
			mouse_sensitivity = 0.20
			return true
		camera_states.RUN:
			current_state = camera_states.RUN
			pos = Vector3(0.0, 1.46, 0.0)
			spring_arm = 2.26
			fov = 75
			hoffset = 0.0
			voffset = 0.0
			min_pitch = -90
			max_pitch = 50
			mouse_sensitivity = 0.20
			return true
		camera_states.ACTIVE:
			current_state = camera_states.ACTIVE
			pos = Vector3(0.0, 1.7, 0.0)
			spring_arm = 1.9
			fov = 65
			hoffset = 0.75
			voffset = 0.0
			min_pitch = -25
			max_pitch = 25
			mouse_sensitivity = 0.1
			return true
		camera_states.FIRE:
			current_state = camera_states.FIRE
			pos = Vector3(0.0, 1.8, 0.0)
			spring_arm = 2.3
			fov = 35
			hoffset = 0.60
			voffset = 0.0
			min_pitch = -25
			max_pitch = 25
			mouse_sensitivity = 0.08
			return true
		_:
			current_state = null
			return false
func are_different_state(state):
	return state != current_state
	
func change_camera(to_value:camera_states):
	if are_different_state(to_value) and set_camera_position_value(to_value):
		var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(main_camera, "h_offset", hoffset, cam_transition_speed)
		tween.tween_property(main_camera, "v_offset", voffset, cam_transition_speed)
		tween.tween_property(main_camera, "follow_offset", pos, cam_transition_speed)
		tween.tween_property(main_camera, "spring_length", spring_arm, cam_transition_speed)
		tween.tween_property(main_camera, "fov", fov, cam_transition_speed)
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees : Vector3
		pcam_rotation_degrees = main_camera.get_third_person_rotation_degrees()
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
		main_camera.set_third_person_rotation_degrees(pcam_rotation_degrees)
