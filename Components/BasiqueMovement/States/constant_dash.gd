extends State
class_name BMC_ConstantDashState

@export var buff_speed: Buff

@onready var bmc: BMC= _obtain_bmc()

var dir := Vector2.RIGHT
var prev_speed: float

func _obtain_bmc() -> BMC:
	var parent: Node= get_parent()
	
	while parent != null:
		if parent is BMC:
			return parent
		parent = parent.get_parent()
	
	return null

func enter() -> void:
	bmc.dir = dir
	
	bmc.charc_stat.append_buff(buff_speed)

####### FAIRE UN BUFF A LA PLACE

func update(_delta: float) -> void:
	bmc.update_velocity_with_dir()

func exit() -> void:
	bmc.charc_stat.remove_buff(buff_speed)
