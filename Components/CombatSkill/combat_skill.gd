extends Component
class_name CombatSkill

@export var auto_process: bool= false

@export var passives: Array[Action]

@export var gap := Vector2.ZERO

var character: Character
var manager: CSManager

func process_trigger(delta: float, _owner: Node= character, _component: Node= self, _manager: Node= manager, _context: Dictionary= context) -> void:
	super.process_trigger(delta, _owner, _component, _manager, _context)
	
	for action in passives:
		action.execute(delta, _owner, _component, _manager, _context)
