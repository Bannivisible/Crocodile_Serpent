extends Node
class_name Component

@onready var object = get_object()

@export var auto_trigger: bool= false
@export var conditions_for_actions_array: Array[ConditionForAction]

var context: Dictionary

func _physics_process(delta: float) -> void:
	if auto_trigger: process_trigger(delta, object, self, self, context)

func process_trigger(delta: float, own: Node= null, component: Node= null, manager: Node= null, contex: Dictionary={}) -> void:
	for conditions_for_actions in conditions_for_actions_array:
		conditions_for_actions.trigger(delta, own, component, manager, contex)

func get_object() -> Node:
	if object != null: return object
	
	if owner is Component: return owner.get_object()
	elif get_parent() is Component: return get_parent().get_object()
	
	return owner

func get_object_node(node_path: NodePath) -> Node:
	if not object: return null
	return object.get_node_or_null(node_path)
