extends Projectile
class_name Stalactite


@onready var state_machine: StateMachine = $StateMachine
@onready var linear_movement: LinearMovement = $StateMachine/LinearMovement


func project() -> void:
	state_machine.current_state = linear_movement
