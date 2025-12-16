extends Component
class_name State

@onready var state_machine: StateMachine= _get_state_machine()

@warning_ignore("unused_signal")
signal state_entered
@warning_ignore("unused_signal")
signal state_exited

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

func is_current_state() -> bool:
	if state_machine is StateMachine:
		return state_machine.current_state == self
	return false

func get_chained_string(separ_symbol: String= "-") -> String:
	var chained: String= ""
	
	if state_machine:
		chained = state_machine.get_chained_string() + separ_symbol + chained
	
	return chained

func get_top_state_machine() -> StateMachine:
	if state_machine:
		return state_machine.get_top_state_machine()
	return self
