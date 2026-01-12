extends State
class_name BMC_RotateDirState

@export var angle_range := Vector2(-PI, PI)
@export var turn_speed: float= 1.5

@onready var bmc := _obtain_bmc()

var neg_action: String= "look up"
var pos_action: String= "look down"

var face_dir := Vector2.RIGHT

func _obtain_bmc() -> BMC:
	var parent: Node= get_parent()
	
	while parent != null:
		if parent is BMC:
			return parent
		parent = parent.get_parent()
	
	return null


#### INHERITENCE ####

func enter() -> void:
	face_dir = bmc.facing_direction

func update(delta: float) -> void:
	var angle := _get_angle() * turn_speed * delta
	
	bmc.dir = bmc.dir.rotated(angle)
	restrict_angle()
	
	bmc.dir = bmc.dir.normalized()
	
	if bmc.facing_node:
		bmc.facing_node.rotate(angle)
		bmc.facing_node.scale.x = face_dir.x

func exit() -> void:
	if bmc.facing_node:
		bmc.facing_node.rotation = 0.0
		bmc.facing_node.scale.x = bmc.facing_direction.x
	
	bmc.dir = bmc.facing_direction

#### LOGIC ####

func _get_angle() -> float:
	return Input.get_axis(neg_action, pos_action)

func restrict_angle() -> void:
	var base_dir := Vector2.RIGHT if bmc.facing_direction.x == 1.0 else Vector2.LEFT
	var angle := - clampf(bmc.dir.angle_to(base_dir), angle_range.x, angle_range.y)
	
	bmc.dir = base_dir.rotated(angle)

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed(neg_action) or Input.is_action_just_pressed(pos_action)) and is_current_state():
		if bmc.facing_direction.x == 1.0:
			neg_action = "look up"
			pos_action = "look down"
		else :
			neg_action = "look down"
			pos_action = "look up"

