extends Condition
class_name ConditionCompareProperty

@export_enum("OWNER" ,"COMPONENT", "CONTEXT") var who= "OWNER"
@export var context_node_name: String

@export var node_path: NodePath= "."
@export var property_name: StringName

@export_enum("EQUAL", "SUPERIOR", "INFERIOR") var operator:= "EQUAL"
@export var comparative: Variant

func is_valid(_delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> bool:
	var node: Node
	
	match who:
		"OWNER": node = owner
		"COMPONENT": node = component
		"CONTEXT": node = context[context_node_name]
	
	var target: Node= node.get_node_or_null(node_path)
	
	if !target: push_warning("the given node path : " + str(node_path) + " is null")
	else :
		if not Utiles.has_property(target, property_name): 
			push_warning("the target : " + target.name + " haven't property named : " + property_name)
		else :
			_operator_logic(target.get(property_name))
	
	return true

func _operator_logic(property: Variant) -> void:
	match operator:
		"EQUAL": _validate(property == comparative)
		"SUPERIOR": _validate(property_name > comparative)
		"INFERIOR": _validate(property_name < comparative)
		
