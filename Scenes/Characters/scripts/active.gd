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
	agent.velocity.x = horizontal.x / delta * 1.5
	agent.velocity.z = horizontal.z / delta * 1.5
	agent.move_character()
	_change()
	_dodge(input_dir)
	
	
func _change() -> void:
	if Input.is_action_just_pressed("e"):
		agent.animation_tree.set_state_animation_direction("de_equip bow", 1)
		agent.change_state(self, "to_inactive")
	if Input.is_action_pressed("lclick") or Input.is_action_pressed("rclick"):
		agent.change_state(self, "to_aim")

func _dodge(input_dir : Vector2) :
	if Input.is_action_just_pressed("alt"):
		var dodge_value = _get_dodge_value(input_dir)
		agent.animation_tree.set_transition_value("d_r transition", "dodge")
		agent.animation_tree.sub_state_transition("dodge sm", dodge_value)
		agent.animation_tree.set_oneshot_active("dodge os")
		
func _get_dodge_value(dodge_value : Vector2):
	match dodge_value:
		Vector2.UP:
			return "dodge back"
		Vector2.DOWN:
			return "dodge front"
		Vector2.RIGHT:
			return "dodge right"
		Vector2.LEFT:
			return "dodge left"
		_: 
			return "dodge front"
