extends LimboState

var movement := -1.0
const SPEED := 1.2
const ROTATION_SPEED = 4.0
var tween = false

func _enter() -> void:
	agent.animation_tree.state_transition("INACTIVE")
	print_debug("entered inactive state")
	

func _exit() -> void:
	print_debug("exited inactive state")	
	
func _update(delta: float) -> void:
	var input_dir := Input.get_vector("a", "d", "s", "w").normalized()
	if input_dir.length() > 0:
		var camera_forward = -agent.camera.global_transform.basis.z
		var camera_right = agent.camera.global_transform.basis.x
		var move_direction = (camera_forward * input_dir.y) + (camera_right * input_dir.x)
		move_direction = move_direction.normalized()
		var target_rotation = atan2(move_direction.x, move_direction.z)
		if agent.rotation.y != target_rotation:
			agent.rotation.y = lerp_angle(agent.rotation.y, target_rotation, ROTATION_SPEED * get_process_delta_time())
		
		tween = 0
		set_velocity()
		if should_run():
			movement = lerp(movement, 1.0, 5 * delta)
		else:
			movement = lerp(movement, 0.0, 3 * delta)
	else:
		if not tween:
			tween = create_tween().bind_node(self)
			var time = movement + 1
			tween.tween_property(self, "movement", -1, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
		set_velocity()
		
	agent.animation_tree.inactive_movement(movement)
	agent.move_and_slide()
		
func set_velocity() -> void :
	var s = -SPEED * agent.animation_tree.get_root_motion_position().z / get_physics_process_delta_time()
	var player_forward = -agent.transform.basis.z
	agent.velocity.x = player_forward.x * s
	agent.velocity.z = player_forward.z * s

func should_run():
	if Input.is_action_pressed("shift"):
		return true
	return false
