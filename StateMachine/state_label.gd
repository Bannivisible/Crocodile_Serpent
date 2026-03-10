extends Label
class_name StateLabel

@export var state_machine: StateMachine= get_parent():
	set = _set_state_machine


#### SETTER ####
func _set_state_machine(value: StateMachine) -> void:
	if state_machine:
		state_machine.state_changed_recur.disconnect(_on_state_machine_state_changed_recur)
	
	state_machine = value
	
	if state_machine:
		state_machine.state_changed_recur.connect(_on_state_machine_state_changed_recur)
		
		if not state_machine.is_node_ready():
			await state_machine.ready
		
		text = get_state_name_recur(state_machine.current_state)

#### BUILT-IN ####
func _ready() -> void:
	add_theme_font_size_override("font_size", 32)

#### LOGIC ####
func get_state_name_recur(state: State) -> String:
	if state != null:
		if state is StateMachine:
			return state.name + " -> " + get_state_name_recur(state.current_state)
		else:
			return state.name
	else:
		return "null"

#### SIGNALS RESPONSES ####
func _on_state_machine_state_changed_recur(state: State, _deep_state: State) -> void:
	text = get_state_name_recur(state)
