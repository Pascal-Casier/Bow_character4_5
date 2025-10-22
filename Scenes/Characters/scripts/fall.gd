extends LimboState


# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	print_debug( "fall state entered")
	var next_state = get_travel_state()
	agent.animation_tree.state_transition(next_state)
	reset()
	
func reset():
	agent.animation_tree.reset_movement()
	
func _exit() -> void:
	print_debug( "fall state exited")
	
func get_travel_state():
	var _last_state = agent.get_previous_state()
	match _last_state:
		"INACTIVE":
			return "INACTIVE FALL"
		"ACTIVE":
			return "ACTIVE FALL"
		_:
			return "ACTIVE FALL"

func _update(delta: float) -> void:
	if agent.is_on_floor():
		agent.animation_tree.direct_sub_state_transition(get_travel_state(), "fall to land")
		agent.change_state(self, land_travel_next())

func land_travel_next():
	var _last_state = agent.get_previous_state()
	if _last_state == "INACTIVE":
		return "to_inactive"
	else:
		return "to_active"
