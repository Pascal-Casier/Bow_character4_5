extends AnimationTree

const ANIMATION_LENGTH_WALK := 1.066
const ANIMATION_LENGTH_RUN := 0.766

var current_blend_position := Vector2.ZERO
var blend_speed := 10.0 # transition speed between animations

@onready var player = $"../../"
 
func _ready() -> void:
	self.active = true
	
func state_transition(state_name : String) -> void:
	var _state_machine_transition = get("parameters/playback")
	_state_machine_transition.travel(state_name)

func inactive_movement(blend_position_value : float) -> void:
	set("parameters/INACTIVE/movement/1/TimeScale/scale", lerp(1.0, ANIMATION_LENGTH_WALK / ANIMATION_LENGTH_RUN, blend_position_value))
	set("parameters/INACTIVE/movement/2/TimeScale/scale", lerp( ANIMATION_LENGTH_RUN / ANIMATION_LENGTH_WALK, 1.0, blend_position_value))
	set("parameters/INACTIVE/movement/blend_position", blend_position_value)

func set_state_animation_direction(node_name:String, direction:int) -> void:
	var _playback = tree_root.get_node(node_name)
	_playback.set_play_mode(direction)
	
func movement(blend_position_value : Vector2) -> void:
	current_blend_position = current_blend_position.move_toward(blend_position_value, blend_speed * get_process_delta_time())
	set("parameters/ACTIVE/movement/blend_position", current_blend_position)

func sub_state_transition(path: String, sub_state_name:String):
	var _state_machine_transition = get("parameters/ACTIVE/" + path + "/playback")
	if _state_machine_transition:
		_state_machine_transition.travel(sub_state_name)
		
func set_transition_value(path : String, value : String): 
	set("parameters/ACTIVE/" + path + "/transition_request", value)
	
func set_oneshot_active(path:String):
	set("parameters/ACTIVE/" + path + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func can_switch_state():
	var _current_state = player.get_state_value()
	match _current_state:
		"ACTIVE":
			if get("parameters/playback").get_current_node() != _current_state:
				return false
			var _dodge = get("parameters/ACTIVE/dodge os/active")
			var _aim = get("parameters/ACTIVE/aim os/active")
			return not(_dodge or _aim)
		_: 
			return true

func direct_sub_state_transition(state_name : String, anim_name : String):
	var _playback = get("parameters/" + state_name + "/playback")
	if _playback:
		_playback.travel(anim_name)

func reset_movement():
	current_blend_position = Vector2.ZERO
	set("parameters/ACTIVE/movement/blend_position", current_blend_position)
	set_oneshot_abort("dodge os")
	set_oneshot_abort("aim os")
	
func set_oneshot_abort(path:String):
	set("parameters/ACTIVE/" + path + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
