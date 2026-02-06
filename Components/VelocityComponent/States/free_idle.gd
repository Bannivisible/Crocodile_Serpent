extends StateMachine
class_name VelocityComponent_FreeState

@export var air_state: VelocityComponent_AirState= get_parent()
@export var gravity_mult: float= 0.0

var prev_gravity: float

func enter() -> void:
	super.enter()
	prev_gravity = air_state.gravity
	air_state.gravity *= gravity_mult

func exit() -> void:
	super.exit()
	air_state.gravity = prev_gravity
