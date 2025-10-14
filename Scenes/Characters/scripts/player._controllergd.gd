extends CharacterBody3D

@export var INACTIVE : LimboState
@export var ACTIVE : LimboState
@export var AIM : LimboState
@export var FALL : LimboState
@export var limbo_state : LimboHSM
@onready var animation_tree = $AnimationMisc/AnimationTree
@onready var camera: PhantomCamera3D = $CameraManager/MainCamera

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
	
	
	
	
	
	
	
	
