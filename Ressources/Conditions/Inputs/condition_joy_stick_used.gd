extends Condition
class_name ConditionJoyStickUsed

@export var deadzone: float = 0.2 
@export var input_left: String = "look left"
@export var input_right: String = "look right"
@export var input_up: String = "look up"
@export var input_down: String = "look down"

@export var custom_key_context: String = "dir"

func is_valid(_delta: float, _owner: Node= null, _component: Node= null, _manager: Node= null, context: Dictionary= {}) -> bool:
	var dir = Input.get_vector(input_left, input_right, input_up, input_down)
	context[custom_key_context]= dir
	
	return _validate(dir.length() > deadzone)
