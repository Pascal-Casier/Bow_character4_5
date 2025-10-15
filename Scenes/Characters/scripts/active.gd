extends LimboState


# Called when the node enters the scene tree for the first time.
func _enter() -> void:
	agent.animation_tree.state_transition("ACTIVE")
	
	print_debug("enter active state")

func _exit() -> void:
	print_debug("exit active state")

func _update(delta:float) -> void:
	agent.rotation_based_on_camera(Vector2(0,1))
	var input_dir = Vector2(
		-Input.get_action_strength("a") + Input.get_action_strength("d"),
		-Input.get_action_strength("s") + Input.get_action_strength("w")
	).normalized()
	agent.animation_tree.movement(input_dir)
	var root_motion = agent.animation_tree.get_root_motion_position()
	var horizontal = (agent.transform.basis.get_rotation_quaternion().normalized() * root_motion)
	agent.velocity.x = horizontal.x / delta * 3.0
	agent.velocity.z = horizontal.z / delta * 3.0
	agent.move_character()
	_change()
	
	
func _change() -> void:
	if Input.is_action_just_pressed("e"):
		agent.animation_tree.set_state_animation_direction("de_equip bow", 1)
		agent.change_state(self, "to_inactive")
