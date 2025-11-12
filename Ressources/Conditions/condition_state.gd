extends Condition
class_name ConditionState

@export_enum("OWNER", "COMPONENT", "CONTEXT") var who: String= "OWNER"
@export var context_object_name: String

@export var state_machine_path: NodePath= "StateMachine"

@export var valid_state: Array[NodePath]:
	set(value):
		if value != valid_state:
			valid_state = value

func is_valid(_delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> bool:
	var state_machine: StateMachine
	
	match who:
		"OWNER": state_machine = owner.get_node_or_null(state_machine_path)
		"COMPONENT" : state_machine = component.get_node_or_null(state_machine_path)
		"CONTEXT":
			var object: Object= Utiles.get_value_if_exist(context, context_object_name)
			if object:
				state_machine = object.get_node_or_null(state_machine_path)
	
	if state_machine:
		return _validate(
			
			state_machine.get_state_name() in _reduce_path_to_name(valid_state)
		)
	return _validate(false)

func _reduce_path_to_name(array_string) -> Array[String]:
	var result: Array[String]
	
	for i in range(valid_state.size()):
		var state_name = array_string[i]
		state_name = Utiles.reduce_string(state_name, state_machine_path, 1)# +1 pour le "/"
		result.append(state_name)
	
	return result
