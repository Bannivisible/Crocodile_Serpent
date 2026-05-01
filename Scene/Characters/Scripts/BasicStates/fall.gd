extends State
class_name FallState

@export var increase_gravity: float= 1000.0

@export var velocity_component: VelocityComponent
@export var jump: State

@export var idle_state_name: String= "Idle"


func enter() -> void:
	velocity_component.gravity += increase_gravity


func update(_delta: float) -> void:
	if owner.is_on_floor():
		state_machine.set_state_with_string(idle_state_name)


func exit() -> void:
	velocity_component.gravity -= increase_gravity


