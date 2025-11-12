extends Condition
class_name ConditionChargeInput

@export var input_action: InputEventAction 
@export var required_time: float= 1.0
@export_range(0.0, 1.0, 0.01) var minimum_rate: float

@export var custom_key_context: String = "charge_rate"

var charge_rate: float= 0.2

func is_valid(delta: float, _owner: Node= null, _component: Node= null, _manager: Node= null, context: Dictionary= {}) -> bool:
	if Input.is_action_pressed(input_action.action):
		charge_rate = clamp(charge_rate  + delta / required_time, 0.0, 1.0)
		context[custom_key_context] = charge_rate
	
	return _validate(charge_rate >= minimum_rate)
