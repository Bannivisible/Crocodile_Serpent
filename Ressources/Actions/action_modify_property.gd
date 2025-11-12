extends Action
class_name ActionModifyProperty

@export_group("Target")
@export_enum("OWNER" ,"COMPONENT", "CONTEXT") var who = "OWNER"
@export_placeholder("The context key if context is who") var context_node_name: String

@export var node_path: NodePath= "."
@export var property_name: StringName


@export_group("New Value")
@export_enum("ARBITRARY", "CONTEXT KEY", "ATTRIBUTE") var method_type= "ARBITRARY"
@export_subgroup("ARBITRARY")
@export var value_arbitrary: Variant

@export_subgroup("CONTEXT KEY")
@export var value_context_key: StringName

@export_subgroup("ATTRIBUTE", "attr_")
@export var attr_attribute_name: StringName
@export_enum("OWNER" ,"COMPONENT", "CONTEXT") var attr_who = "OWNER"
@export var attr_context_node_name: String
@export var attr_node_path: NodePath= "."

func execute(_delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> void:
	var node: Node
	
	match who:
		"OWNER": node = owner
		"COMPONENT": node = component
		"CONTEXT": 
			if not context.has(context_node_name): return
			node = context[context_node_name]
	
	var target: Node= node.get_node_or_null(node_path)
	if !target: push_warning("the given node path : " + str(node_path) + " is null")
	
	else :
		if not Utiles.has_property(target, property_name): 
			push_warning("the target : " + target.name + " haven't property named : " + property_name)
		else :
			var value: Variant = _get_new_value(owner, component, context)
			target.set(property_name, value)

func _get_new_value(owner: Node, component: Node, context: Dictionary) -> Variant:
	var value: Variant
	
	match method_type:
		"ARBITRARY": value = value_arbitrary
		"CONTEXT KEY": value = _value_as_context_key_logic(context)
		"ATTRIBUTE": value = _value_as_attribute_logic(owner, component, context)
	
	return value

func _value_as_context_key_logic(context: Dictionary) -> Variant:
	return Utiles.get_value_if_exist(context, value_context_key)

func _value_as_attribute_logic(owner: Node, component: Node, context: Dictionary) -> Variant:
	var node: Node
	
	match attr_who:
		"OWNER": node = owner
		"COMPONENT": node = component
		"CONTEXT": 
			if not context.has(attr_context_node_name): return
			node = context[attr_context_node_name]
	
	var target: Node= node.get_node_or_null(attr_node_path)
	if !target: push_warning("the given attribute node path : " + str(attr_node_path) + " is null")
	else :
		if not Utiles.has_property(target, attr_attribute_name): 
			push_warning("the target : " + target.name + " haven't attribute named : " + attr_attribute_name)
		else :
			return target.get(attr_attribute_name)
	return null
