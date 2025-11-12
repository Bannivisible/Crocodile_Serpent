extends Condition
class_name ConditionInput

@export var input_action: InputEventAction 

@export_enum("JustPressed", "Pressed", "JustRealease") var input_type = "JustPressed"

func is_valid(_delta: float, _owner: Node= null, _component: Node= null, _manager: Node= null, _context: Dictionary= {}) -> bool:
	match input_type:
		"JustPressed":return _validate(Input.is_action_just_pressed(input_action.action))
		"Pressed": return _validate(Input.is_action_pressed(input_action.action))
		"JustRealease": return _validate(Input.is_action_just_released(input_action.action))
	
	return true
