extends State

@export var velocity_component: VelocityComponent

@export var angle_range := Vector2(-PI, PI)
@export var turn_speed: float= 1.5

@export var buff_speed: Buff

@onready var controler: Controler = $"../../PlayerControler"

var neg_action: String= "up"
var pos_action: String= "down"

##### INHERITENCE ####

func enter() -> void:
	velocity_component.pos_x_face_inverser.active = false
	velocity_component.scale_x_face_inverser.active = false
	velocity_component.dir = velocity_component.face_dir
	velocity_component.update_velocity()
	velocity_component.rotation_leader.nodes.append(owner)
	
	controler.active = false
	
	if buff_speed:
		velocity_component.charac_stat.append_buff(buff_speed)


func update(delta: float) -> void:
	var angle := _get_angle() * turn_speed * delta
	
	velocity_component.dir = velocity_component.dir.rotated(angle)
	restrict_angle()
	
	velocity_component.dir = velocity_component.dir.normalized()
	
	velocity_component.update_velocity()


func exit() -> void:
	controler.active = true
	
	velocity_component.scale_x_face_inverser.active = true
	velocity_component.pos_x_face_inverser.active = true
	_set_face_dir()
	velocity_component.dir = Vector2.ZERO
	velocity_component.rotation_leader.nodes.erase(owner)
	
	if buff_speed:
		velocity_component.charac_stat.remove_buff(buff_speed)

##### LOGIC ####
func _get_angle() -> float:
	return Input.get_axis(neg_action, pos_action)


func restrict_angle() -> void:
	var base_dir := Vector2.RIGHT if velocity_component.face_dir.x == 1.0 else Vector2.LEFT
	var angle := - clampf(velocity_component.dir.angle_to(base_dir), angle_range.x, angle_range.y)
	
	velocity_component.dir = base_dir.rotated(angle)


func _set_face_dir() -> void:
	var face_dir_x: float= sign(velocity_component.dir.x)
	velocity_component.face_dir = Vector2.RIGHT * face_dir_x
	velocity_component.face_dir_changed.emit(velocity_component.face_dir)

func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed(neg_action) or Input.is_action_just_pressed(pos_action)) and is_current_state():
		if velocity_component.face_dir.x == 1.0:
			neg_action = "up"
			pos_action = "down"
		else :
			neg_action = "down"
			pos_action = "up"
