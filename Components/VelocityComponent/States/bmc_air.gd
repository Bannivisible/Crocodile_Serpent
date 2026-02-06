extends StateMachine
class_name VelocityComponent_AirState

@export var gravity: float = 200.0

func update(delta: float) -> void:
	if !owner.object.is_on_floor():
		owner.object.velocity.y += gravity * delta
