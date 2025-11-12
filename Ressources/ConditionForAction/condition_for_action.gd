extends Resource
class_name ConditionForAction

@export var conditions: Array[Condition]:
	set(value):
		if value != conditions:
			conditions = value
			_init_condition()

@export var actions: Array[Action]

@export var reversed_actions: Array[Action]

var triggered := false:
	set(value):
		if value != triggered:
			triggered = value
			triggered_change.emit(triggered)

signal triggered_change(triggered)

func check(delta: float, owner: Node= null, component: Node= null, manager: Node= null, context: Dictionary= {}) -> bool:
	for condition in conditions:
		if not condition.is_valid(delta, owner, component, manager, context): return false
	return true

func trigger(delta: float, owner: Node= null, component: Node= null, manager: Node= null, context: Dictionary= {}) -> void:
	if check(delta, owner, component, manager, context):
		triggered = true
		
		for action in actions:
			action.execute(delta, owner, component, manager, context)
		
	else :
		triggered = false
		for action in reversed_actions:
			action.execute(delta, owner, component, manager, context)

func _init_condition() -> void:
	for condition in conditions:
		connect("triggered_change", condition._on_ActionForCondition_triggered_change)
