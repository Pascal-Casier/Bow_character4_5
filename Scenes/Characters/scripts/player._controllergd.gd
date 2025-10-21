extends CharacterBody3D

@export var INACTIVE : LimboState
@export var ACTIVE : LimboState
@export var AIM : LimboState
@export var FALL : LimboState
@export var limbo_state : LimboHSM
@onready var animation_tree = $AnimationMisc/AnimationTree
@onready var camera: PhantomCamera3D = $CameraManager/MainCamera

const SPEED := 1.5
const ROTATION_SPEED := 7.0
const GRAVITY := 10.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_initialize_state_machine()
	_setup_state_transitions()
	
func _initialize_state_machine() -> void:
	limbo_state.initial_state = INACTIVE
	limbo_state.initialize(self)
	limbo_state.set_active(true)

func _setup_state_transitions() -> void:
	limbo_state.add_transition(INACTIVE, ACTIVE, "to_active")
	limbo_state.add_transition(ACTIVE, INACTIVE, "to_inactive")
	limbo_state.add_transition(ACTIVE, AIM, "to_aim")
	limbo_state.add_transition(AIM, ACTIVE, "to_active")
	limbo_state.add_transition(INACTIVE, FALL, "to_fall")
	limbo_state.add_transition(ACTIVE, FALL, "to_fall")
	limbo_state.add_transition(AIM, FALL, "to_fall")
	limbo_state.add_transition(FALL, INACTIVE, "to_inactive")
	limbo_state.add_transition(FALL, ACTIVE, "to_active")

func change_state(state_name:LimboState, state : String)-> void:
	state_name.dispatch(state)
	
func set_velocities() -> void:
	var s = -SPEED * animation_tree.get_root_motion_position().z / get_physics_process_delta_time()
	var player_forward = -transform.basis.z
	velocity.x = player_forward.x * s
	velocity.z = player_forward.z * s

func rotation_based_on_camera(input_dir : Vector2) -> void:
	var camera_forward = -camera.global_transform.basis.z
	var camera_right = camera.global_transform.basis.x
	var move_direction = (camera_forward * input_dir.y) + (camera_right * input_dir.x)
	move_direction = move_direction.normalized()
	var target_rotation = atan2(move_direction.x, move_direction.z)
	if rotation.y != target_rotation:
		rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * get_process_delta_time())
	
func move_character():
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "standing aim recoil":
		change_state(AIM, "to_active")
	elif anim_name == "standing equip bow":
		change_state(get_current_state(), get_next_state_event())
		
func get_current_state():
	return limbo_state.get_active_state()
	
func get_next_state_event():
	if get_current_state() == INACTIVE:
		return "to_active"
	return "to_inactive"
	
func get_state_value():
	return get_current_state().name

func move():
	var root_motion = animation_tree.get_root_motion_position()
	var horizontal = (transform.basis.get_rotation_quaternion().normalized() * root_motion)
	velocity.x = horizontal.x / get_process_delta_time() * 1.5
	velocity.z = horizontal.z / get_process_delta_time() * 1.5
	

func get_previous_state() -> String:
	return limbo_state.get_previous_active_state().name

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = clamp(velocity.y - GRAVITY * delta, -GRAVITY, GRAVITY)
	else:
		velocity.y = 0
	move_character()
