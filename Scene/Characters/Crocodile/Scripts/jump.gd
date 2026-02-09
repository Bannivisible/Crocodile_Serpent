extends State

@export var force: float= 400.0


@onready var velocity_component: VelocityComponent = $"../../VelocityComponent"


func enter() -> void:
	velocity_component.jump(force)


func update(_delta: float) -> void:
	if sign(owner.velocity.y) == 1.0:
		
		state_machine.set_state_with_string("Fall")
