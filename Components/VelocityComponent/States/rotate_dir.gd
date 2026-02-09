extends State
class_name VelocityComponent_RotateDirState

@export var angle_range := Vector2(-PI, PI)
@export var turn_speed: float= 1.5

@onready var velocity_component := _obtain_velocity_component()

var neg_action: String= "up"
var pos_action: String= "down"

var face_dir := Vector2.RIGHT

func _obtain_velocity_component() -> VelocityComponent:
	var parent: Node= get_parent()
	
	while parent != null:
		if parent is VelocityComponent:
			return parent
		parent = parent.get_parent()
	
	return null


#### INHERITENCE ####

func enter() -> void:
	face_dir = velocity_component.facing_direction

func update(delta: float) -> void:
	var angle := _get_angle() * turn_speed * delta
	
	velocity_component.dir = velocity_component.dir.rotated(angle)
	restrict_angle()
	
	velocity_component.dir = velocity_component.dir.normalized()
	
	if velocity_component.facing_node:
		velocity_component.facing_node.rotate(angle)
		velocity_component.facing_node.scale.x = face_dir.x

func exit() -> void:
	if velocity_component.facing_node:
		velocity_component.facing_node.rotation = 0.0
		velocity_component.facing_node.scale.x = velocity_component.facing_direction.x
	
	velocity_component.dir = velocity_component.facing_direction

#### LOGIC ####

func _get_angle() -> float:
	return Input.get_axis(neg_action, pos_action)

func restrict_angle() -> void:
	var base_dir := Vector2.RIGHT if velocity_component.facing_direction.x == 1.0 else Vector2.LEFT
	var angle := - clampf(velocity_component.dir.angle_to(base_dir), angle_range.x, angle_range.y)
	
	velocity_component.dir = base_dir.rotated(angle)

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed(neg_action) or Input.is_action_just_pressed(pos_action)) and is_current_state():
		if velocity_component.facing_direction.x == 1.0:
			neg_action = "up"
			pos_action = "down"
		else :
			neg_action = "down"
			pos_action = "up"

