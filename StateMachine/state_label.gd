extends Label
class_name StateLabel


func _ready() -> void:
	get_parent().state_changed_recur.connect(on_StateMachine_state_changed_recur)

func on_StateMachine_state_changed_recur(state: State, _deep_state: State) -> void:
	text = get_state_name_recur(state)

func get_state_name_recur(state: State) -> String:
	if state != null:
		if state is StateMachine:
			return state.name + " -> " + get_state_name_recur(state.current_state)
		else:
			return state.name
	else:
		return "null"
