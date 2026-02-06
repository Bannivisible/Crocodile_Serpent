extends WeaponAttackState

@export var center_bone_path: NodePath

var state_machine_x: StateMachine
var state_machine_y: StateMachine

func enter() -> void:
	super.enter()
	
	var velocity_component: VelocityComponent= object.get_node("VelocityComponent")
	state_machine_x = velocity_component.state_machine_x
	state_machine_y = velocity_component.state_machine_y
	
	var constant_dash: VelocityComponent_ConstantDashState= velocity_component.get_node("StateMachineX/ConstantDash")
	constant_dash.dir = velocity_component.facing_direction
	
	state_machine_x.set_state(constant_dash)
	state_machine_y.set_state_with_string("RotateDir")

func exit() -> void:
	super.exit()
	
	state_machine_x.set_state_with_string("Idle")
	state_machine_y.set_state_with_string("Fall")
	
	object.get_node(center_bone_path).rotation = 0.0
