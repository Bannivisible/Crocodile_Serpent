extends StateMachine
class_name BMC_AirState

@export var gravity: float = 200.0

func _physics_process(delta: float) -> void:
	if !owner.object.is_on_floor():
		owner.object.velocity.y += gravity * delta
