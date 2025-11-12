@abstract
extends Resource
class_name Condition

@export var reversed: bool= false

@abstract
func is_valid(delta: float, owner: Node= null, component: Node= null, manager: Node= null, context: Dictionary= {}) -> bool

func _validate(condition: bool) -> bool:
	var validation = condition if not reversed else !condition
	return validation

func _on_ActionForCondition_triggered_change(_triggered: bool) -> void:
	pass
