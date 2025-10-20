extends LimboState


func _enter():
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
	var root_motion = agent.animation_tree.get_root_motion_position()
	var horizontal = (agent.transform.basis.get_rotation_quaternion().normalized() * root_motion)
	agent.velocity.x = horizontal.x / delta * 1.5
	agent.velocity.z = horizontal.z / delta * 1.5
	agent.move_character()
	_change()
	
func _change():
	if Input.is_action_just_released("lclick") or Input.is_action_just_released("rclick"):
		agent.animation_tree.sub_state_transition("aim sm", "release")
		agent.change_state(self, "to_active")
