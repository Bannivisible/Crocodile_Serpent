extends Label
class_name StateLabel


func _ready() -> void:
	var state_machine: StateMachine= get_parent()
	state_machine.state_changed_recur.connect(_on_StateMachine_state_changed_recur)
	
	if not state_machine.is_node_ready():
		await state_machine.ready
	
	text = get_state_name_recur(state_machine.current_state)

func get_state_name_recur(state: State) -> String:
	if state != null:
		if state is StateMachine:
			return state.name + " -> " + get_state_name_recur(state.current_state)
		else:
			return state.name
	else:
		return "null"

func _on_StateMachine_state_changed_recur(state: State, _deep_state: State) -> void:
	text = get_state_name_recur(state)
