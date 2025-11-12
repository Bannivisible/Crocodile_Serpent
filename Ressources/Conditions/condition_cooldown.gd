extends Condition
class_name ConditionCooldown

@export_range(0.0, 99.9, 0.1) var cool_down: float= 0.5
var current_cooldown: float= 0.0

func is_valid(delta: float, _owner: Node= null, _component: Node= null, _manager: Node= null, _context: Dictionary= {}) -> bool:
	current_cooldown = max(current_cooldown - delta, 0.0)
	
	return _validate(is_cooldown_running())

func is_cooldown_running() -> bool:
	return current_cooldown != 0.0

func _on_ActionForCondition_triggered_change(triggered: bool) -> void:
	if !triggered: return
	current_cooldown = cool_down
