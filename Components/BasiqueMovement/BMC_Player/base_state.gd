extends StateMachine

func _input(_event: InputEvent) -> void:
	if not is_current_state(): return
	
	var bmc: BMC= owner
	bmc.dir.x = Input.get_axis("look left", "look right")
