extends LimboState

var movement := -1.0

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
	agent.move_and_slide()
		
func should_run():
	if Input.is_action_pressed("shift"):
		return true
	return false
