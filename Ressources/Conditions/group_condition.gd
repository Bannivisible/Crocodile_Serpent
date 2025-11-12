extends Condition
class_name GroupCondition

@export var conditions: Array[Condition]

@export_enum("AND", "OR") var logic= "AND" 

func is_valid(delta: float, owner: Node= null, component: Node= null, manager: Node= null, context: Dictionary= {}) -> bool:
	match logic:
		"AND": return _validate(_AND_logic(delta, owner, component, manager, context))
		"OR": return _validate(_OR_logic(delta, owner, component, manager, context))
	return true

func _AND_logic(delta: float, owner: Node= null, component: Node= null, manager: Node= null, context: Dictionary= {}) -> bool:
	for condition in conditions:
		if !condition.is_valid(delta, owner, component, manager, context):
			return false
	return true

func _OR_logic(delta: float, owner: Node= null, component: Node= null, manager: Node= null, context: Dictionary= {}) -> bool:
	for condition in conditions:
		if condition.is_valid(delta, owner, component, manager, context):
			return true
	return false
