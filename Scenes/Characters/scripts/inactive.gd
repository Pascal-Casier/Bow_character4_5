extends LimboState

var movement := -1.0
#const SPEED := 1.2
#const ROTATION_SPEED = 4.0
var tween = false

func _enter() -> void:
	agent.animation_tree.state_transition("INACTIVE")
	print_debug("entered inactive state")
	

func _exit() -> void:
	print_debug("exited inactive state")	
	
func _update(delta: float) -> void:
	var input_dir := Input.get_vector("a", "d", "s", "w").normalized()
	if input_dir.length() > 0:
		agent.rotation_based_on_camera(input_dir)
		#var camera_forward = -agent.camera.global_transform.basis.z
		#var camera_right = agent.camera.global_transform.basis.x
		#var move_direction = (camera_forward * input_dir.y) + (camera_right * input_dir.x)
		#move_direction = move_direction.normalized()
		#var target_rotation = atan2(move_direction.x, move_direction.z)
		#if agent.rotation.y != target_rotation:
			#agent.rotation.y = lerp_angle(agent.rotation.y, target_rotation, ROTATION_SPEED * get_process_delta_time())
		if tween:
			tween.kill()
			tween = null
			
		agent.set_velocities()
		if should_run():
			movement = lerp(movement, 1.0, 5 * delta)
		else:
			movement = lerp(movement, 0.0, 3 * delta)
	else:
		if not tween:
			tween = create_tween().bind_node(self)
			var time = movement + 1
			tween.tween_property(self, "movement", -1, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
		agent.set_velocities()
		
	agent.animation_tree.inactive_movement(movement)
	agent.move_character()
	_change()
		

func should_run():
	if Input.is_action_pressed("shift"):
		return true
	return false

func _change() -> void:
	if Input.is_action_just_pressed("lclick") or Input.is_action_just_pressed("rclick") or Input.is_action_just_pressed("e"):
		agent.animation_tree.set_state_animation_direction("de_equip bow", 0)
		agent.change_state(self, "to_active")
	
