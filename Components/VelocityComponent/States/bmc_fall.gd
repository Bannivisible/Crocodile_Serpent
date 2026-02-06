extends State
class_name VelocityComponent_FallState

@export var gravity_increase: float = 300.0

var gravity: float

func enter() -> void:
	owner.object.velocity.y = 0.0
	state_machine.gravity += gravity_increase

func exit() -> void:
	state_machine.gravity -= gravity_increase
