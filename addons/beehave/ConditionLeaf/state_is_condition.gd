@tool
extends ConditionLeaf

@export var state_machine: StateMachine
@export var state_name: StringName

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if state_machine.get_state_name() == state_name:
		return SUCCESS
	
	return FAILURE

