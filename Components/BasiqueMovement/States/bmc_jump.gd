extends State
class_name BMC_JumpState

@export var force: float = 400

func enter() -> void:
	owner.object.velocity.y = -force
