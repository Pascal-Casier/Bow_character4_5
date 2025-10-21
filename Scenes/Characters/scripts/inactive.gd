extends LimboState

var movement := -1.0

var tween = false
var is_falling := false

func _enter() -> void:
	is_falling = false
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
		agent.set_velocities()
		
	agent.animation_tree.inactive_movement(movement)
	_change()
	_fall()
		

func should_run():
	if Input.is_action_pressed("shift"):
		return true
	return false

func _change() -> void:
	if (Input.is_action_just_pressed("lclick") or Input.is_action_just_pressed("rclick") or Input.is_action_just_pressed("e")) and agent.animation_tree.can_switch_state():
		agent.animation_tree.set_state_animation_direction("de_equip bow", 0)
		agent.animation_tree.state_transition("ACTIVE")
	
func _fall():
	if not agent.is_on_floor() and not is_falling:
		is_falling = true
		await get_tree().create_timer(0.2).timeout
		if not agent.is_on_floor():
			agent.change_state(self, "to_fall")
		else:
			is_falling = false
