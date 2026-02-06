extends State
class_name VelocityComponent_ConstantDashState

@export var buff_speed: Buff

@onready var velocity_component: VelocityComponent= _obtain_VelocityComponent()

var dir := Vector2.RIGHT
var prev_speed: float

func _obtain_VelocityComponent() -> VelocityComponent:
	var parent: Node= get_parent()
	
	while parent != null:
		if parent is VelocityComponent:
			return parent
		parent = parent.get_parent()
	
	return null

func enter() -> void:
	velocity_component.dir = dir
	
	velocity_component.charac_stat.append_buff(buff_speed)

####### FAIRE UN BUFF A LA PLACE

func update(_delta: float) -> void:
	velocity_component.update_velocity_with_dir()

func exit() -> void:
	velocity_component.charac_stat.remove_buff(buff_speed)
