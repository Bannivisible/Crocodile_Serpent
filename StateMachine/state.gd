extends Component
class_name State

@onready var state_machine: StateMachine= _get_state_machine()

func _get_state_machine() -> StateMachine:
	if get_parent() is StateMachine:
		return get_parent()
	return null


func enter() -> void:
	pass

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass

func is_current_state():
	if state_machine is StateMachine:
		return state_machine.current_state == self
