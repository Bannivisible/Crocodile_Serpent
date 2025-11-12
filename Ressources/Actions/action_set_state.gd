extends Action
class_name ActionSetState

@export_enum("OWNER" ,"COMPONENT", "CONTEXT") var who= "OWNER"
@export var context_object_name: String

@export var state_machine_path: NodePath= "StateMachine"

@export var state: NodePath

@export var set_null: bool= false

func execute(_delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> void:
	var state_machine: StateMachine
	
	match who:
		"OWNER": state_machine = owner.get_node_or_null(state_machine_path)
		"COMPONENT" : state_machine = component.get_node_or_null(state_machine_path)
		"CONTEXT":
			if not context.has(context_object_name): return
			state_machine = context[context_object_name].get_node_or_null(state_machine_path)
	
	
	if state_machine:
		if set_null: state_machine.current_state = null
		else :
			var state_name = Utiles.reduce_string(state, state_machine_path, 1)
			state_machine.set_state_with_string(state_name)
