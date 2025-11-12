extends Resource
class_name AdditionalState

@export var name: String

@export var state_script: Script

@export var parent_path: NodePath= "."

@export var conditions: Array[Condition]

var cfa: ConditionForAction

func init_state() -> void:
	cfa = ConditionForAction.new()
	cfa.conditions = conditions
	
	var action := ActionSetState.new()
	action.who = "CONTEXT"
	action.context_object_name = "state_machine"
	action.state_machine_path = "."
	action.state = name
	
	cfa.actions.append(action)

func process_conditions(delta: float, owner: Node, component: Node, manager: Node, context: Dictionary) -> void:
	cfa.trigger(delta, owner, component, manager, context)
