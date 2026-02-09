extends State

@export var increase_gravity: float
@export var jump_mitigation: float= 4.0

@onready var velocity_component: VelocityComponent = $"../../VelocityComponent"
@onready var jump: Node = $"../Jump"


func enter() -> void:
	velocity_component.gravity += increase_gravity


func update(_delta: float) -> void:
	if owner.is_on_floor():
		state_machine.set_state_with_string("Idle")


func exit() -> void:
	velocity_component.gravity -= increase_gravity
