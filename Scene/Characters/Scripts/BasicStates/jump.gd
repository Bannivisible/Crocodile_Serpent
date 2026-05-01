extends State
class_name JumpState

@export var force: float= 1500.0

@export var fall_state_name: String= "Fall"

@onready var velocity_component: VelocityComponent = $"../../VelocityComponent"


func enter() -> void:
	velocity_component.jump(force)


func update(_delta: float) -> void:
	if sign(owner.velocity.y) == 1.0 and fall_state_name != "":
		
		state_machine.set_state_with_string(fall_state_name)


func get_air_time() -> float:
	return force / velocity_component.gravity
