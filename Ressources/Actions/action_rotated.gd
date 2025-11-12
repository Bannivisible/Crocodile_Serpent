extends Action
class_name ActionRotated

@export_enum("OWNER" ,"COMPONENT", "CONTEXT") var who= "OWNER"
@export var context_object_name: String

@export var object_path: NodePath= "."

@export var instant: bool= false
@export var speed: float= 10.0


func execute(delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> void:
	var dir: Vector2 = context["dir"]
	var angle: float= Vector2.RIGHT.angle_to(dir)
	
	var object: Node2D
	
	match who:
		"OWNER": object = owner.get_node_or_null(object_path)
		"COMPONENT" : object = component.get_node_or_null(object_path)
		"CONTEXT": object = context[context_object_name].get_node_or_null(object_path)
	
	if object:
		if instant: object.transform.rotated(angle)
		
		else : object.rotation = lerp(object.rotation, angle, delta * speed)
	
