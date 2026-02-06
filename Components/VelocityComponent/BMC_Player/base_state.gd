extends StateMachine

func _input(_event: InputEvent) -> void:
	if not is_current_state(): return
	
	var velocity_component: VelocityComponent= owner
	velocity_component.dir.x = Input.get_axis("look left", "look right")
