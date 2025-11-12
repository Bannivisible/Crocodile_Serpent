extends Action
class_name ActionCallMethod

@export_enum("OWNER" ,"COMPONENT", "CONTEXT") var who= "OWNER"
@export var target_path: NodePath= "."

@export_placeholder("The context key if context is who") var context_object_key: String

@export var method_name: String
@export var parameters: Array[Variant] = []


func execute(_delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> void:
	var object: Node
	match who:
		"OWNER": object = owner
		"COMPONENT": object = component
		"CONTEXT":
			if not context.has(context_object_key): return
			object = context[context_object_key]
	
	var target := object.get_node_or_null(target_path)
	if target:
		
		if target.has_method(method_name): target.callv(method_name, parameters)
		else : push_warning("the given methode name : " + method_name + "dosn't existed")
		
	else :
		push_warning("the given target path :" + str(target_path) + " is null")
	
