extends Node
class_name HelpRequest


@export_multiline() var text: String

@export var request_on_enter_tree: bool= true

@export var request_states: Array[State]= []:
	set = _set_request_state

@export var show_help: bool= true

#### SETTER ####
func _set_request_state(value) -> void:
	request_states = value
	
	for state in request_states:
		state.state_entered.connect(_on_request_state_entered)


#### BUILT IN ####
func _enter_tree() -> void:
	if request_on_enter_tree:
		Events.request_help.emit(text, show_help)


#### SIGNAL RESPONSES ####
func _on_request_state_entered() -> void:
	Events.request_help.emit(text, show_help)

