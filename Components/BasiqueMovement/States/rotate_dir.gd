extends State
class_name BMC_RotateDirState

@export var angle_range := Vector2(PI, -PI)
@export var turn_speed: float= 1.0

@onready var bmc := _obtain_bmc()

var angle: float= 0.0

func _obtain_bmc() -> BMC:
	var parent: Node= get_parent()
	
	while parent != null:
		if parent is BMC:
			return parent
		parent = parent.get_parent()
	
	return null

#func rotate_dir(angle: float) -> void:
	#if not is_current_state(): return
	#
	#bmc.dir.rotated(angle)
	#if bmc.facing_node:
		#bmc.facing_node.rotation = bmc.dir.angle()

func update(_delta: float) -> void:
	#bmc.dir.rotated(-PI/2 * turn_speed * delta)
	#bmc.dir = bmc.dir.normalized()
	#bmc.update_velocity_with_dir()
	
	print(bmc.dir)
	
	if bmc.facing_node:
		bmc.facing_node.rotation = -PI/2

func exit() -> void:
	if bmc.facing_node:
		bmc.facing_node.rotation = 0.0
