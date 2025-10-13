extends AnimationTree

const ANIMATION_LENGTH_WALK := 1.066
const ANIMATION_LENGTH_RUN := 0.766
func _ready() -> void:
	self.active = true
	
func state_transition(state_name : String) -> void:
	var _state_machine_transition = get("parameters/playback")
	_state_machine_transition.travel(state_name)

func inactive_movement(blend_position_value : float) -> void:
	set("parameters/INACTIVE/movement/1/TimeScale/scale", lerp(1.0, ANIMATION_LENGTH_WALK / ANIMATION_LENGTH_RUN, blend_position_value))
	set("parameters/INACTIVE/movement/2/TimeScale/scale", lerp( ANIMATION_LENGTH_RUN / ANIMATION_LENGTH_WALK, 1.0, blend_position_value))
	set("parameters/INACTIVE/movement/blend_position", blend_position_value)
