extends State
class_name BMC_ConstantDashState

@export var mult_speed: float= 1.0

@onready var bmc: BMC= _obtain_bmc()

var dir := Vector2.RIGHT


func _obtain_bmc() -> BMC:
	var parent: Node= get_parent()
	
	while parent != null:
		if parent is BMC:
			return parent
		parent = parent.get_parent()
	
	return null

func enter() -> void:
	bmc.dir = dir
	bmc.character.velocity = bmc.dir * bmc.speed.value * BMC_MoveState.MULT_SPEED * mult_speed

