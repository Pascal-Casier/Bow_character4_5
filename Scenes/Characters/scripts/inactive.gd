extends LimboState

var movement := -1.0
const SPEED := 1.2

func _enter() -> void:
	agent.animation_tree.state_transition("INACTIVE")
	print_debug("entered inactive state")
	

func _exit() -> void:
	print_debug("exited inactive state")	
	
func _update(delta: float) -> void:
	var input_dir := Input.get_vector("a", "s", "d", "w").normalized()
	if input_dir.length() > 0:
		var s = -SPEED * agent.animation_tree.get_root_motion_position().z / get_physics_process_delta_time()
		var player_forward = -agent.transform.basis.z
		agent.velocity.x = player_forward.x * s
		agent.velocity.z = player_forward.z * s
		movement = lerp(movement, 0.0, 3 * delta)
		agent.animation_tree.inactive_movement(movement)
		agent.move_and_slide()
		
		
