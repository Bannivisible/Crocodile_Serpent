extends Node
class_name Component

@onready var object = _get_object()

@export var auto_trigger: bool= false
@export var conditions_for_actions_array: Array[ConditionForAction]

var context: Dictionary

func _physics_process(delta: float) -> void:
	if auto_trigger: process_trigger(delta, object, self, self, context)

func process_trigger(delta: float, own: Node= null, component: Node= null, manager: Node= null, contex: Dictionary={}) -> void:
	for conditions_for_actions in conditions_for_actions_array:
		conditions_for_actions.trigger(delta, own, component, manager, contex)

func _get_object() -> Node:
	if object != null: return object
	
	if owner is Component:
		return owner._get_object()
	return owner
