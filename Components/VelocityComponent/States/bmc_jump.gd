extends State
class_name VelocityComponent_JumpState

@export var force: float = 400

func enter() -> void:
	owner.object.velocity.y = -force
