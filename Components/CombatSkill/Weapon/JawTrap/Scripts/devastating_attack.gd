extends WeaponAttackState


func enter() -> void:
	super.enter()
	
	var state_machine_x: StateMachine= object.get_node("BMC").state_machine_x
	state_machine_x.set_state_with_string("FreeIdle")

func exit() -> void:
	super.exit()
	
	var state_machine_x: StateMachine= object.get_node("BMC").state_machine_x
	state_machine_x.set_state_with_string("Grounded")
