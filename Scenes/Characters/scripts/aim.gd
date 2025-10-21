extends LimboState

var is_falling := false

func _enter():
	is_falling = false
	print_debug("entered aim state")
	agent.animation_tree.set_oneshot_active("aim os")
	
func _exit():
	print_debug("exited aim state")
func _update(delta: float) -> void:
	agent.rotation_based_on_camera(Vector2(0,1))
	var input_dir = Vector2(
		-Input.get_action_strength("a") + Input.get_action_strength("d"),
		-Input.get_action_strength("s") + Input.get_action_strength("w")
	).normalized()
	agent.animation_tree.movement(input_dir)
	agent.move()
	_change()
	_fall()
	
func _change():
	if (Input.is_action_just_released("lclick") or Input.is_action_just_released("rclick")) and agent.animation_tree.can_switch_state():
		agent.animation_tree.sub_state_transition("aim sm", "release")

func _fall():
	if not agent.is_on_floor() and not is_falling:
		is_falling = true
		await get_tree().create_timer(0.2).timeout
		if not agent.is_on_floor():
			agent.change_state(self, "to_fall")
		else:
			is_falling = false
