extends WeaponAttackState

@export var center_bone_path: NodePath

var state_machine_x: StateMachine
var state_machine_y: StateMachine

func enter() -> void:
	super.enter()
	
	var bmc: BMC= object.get_node("BMC")
	state_machine_x = bmc.state_machine_x
	state_machine_y = bmc.state_machine_y
	
	var constant_dash: BMC_ConstantDashState= bmc.get_node("StateMachineX/ConstantDash")
	constant_dash.dir = bmc.facing_direction
	
	state_machine_x.set_state(constant_dash)
	state_machine_y.set_state_with_string("RotateDir")

func exit() -> void:
	super.exit()
	
	state_machine_x.set_state_with_string("Idle")
	state_machine_y.set_state_with_string("Fall")
	
	object.get_node(center_bone_path).rotation = 0.0
