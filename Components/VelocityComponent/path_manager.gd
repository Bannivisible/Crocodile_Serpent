extends Node
class_name PathManager

enum MOVE_MODE{
	WALK,
	FLY
}


@export var active: bool= false:
	set = _set_active
@export var path: Array[Vector2]

@export var move_mode: MOVE_MODE

@onready var vel_comp: VelocityComponent= owner

signal target_reached(pos: Vector2)
signal target_changed(pos: Vector2)
signal path_updated(pos_id: int)

#### SETTER ####
func _set_active(value: bool) -> void:
	active = value
	
	if not path.is_empty(): _target_pos(path[0])
	
	set_physics_process(active)


#### GETTER ####


#### BUILT-IN ####
func _ready() -> void:
	set_physics_process(active)
	
	target_reached.connect(_on_target_reached)


func _physics_process(delta: float) -> void:
	_move_along_path(delta)


#### LOGIC ####
func add_target_at_begining(target: Vector2) -> void:
	path.push_front(target)
	path_updated.emit(0)


func add_target_at_end(target: Vector2) -> void:
	path.append(target)
	path_updated.emit(len(path) - 1)


func _move_along_path(delta: float) -> void:
	if path.is_empty(): return
	
	var target: Vector2= path[0]
	_target_pos(target)
	var dist: float= vel_comp.character.global_position.distance_to(target)
	
	if dist < vel_comp.speed * vel_comp.MULT_SPEED * delta:
		vel_comp.character.global_position = target
		target_reached.emit(target)


func _target_pos(target: Vector2) -> void:
	match move_mode:
		MOVE_MODE.WALK:
			var dir := vel_comp.dir.direction_to(target)
			vel_comp.dir.x = -signf(dir.x)
			vel_comp.update_velocity_x()
		
		MOVE_MODE.FLY:
			vel_comp.direct_to(target)
			vel_comp.update_velocity()


#### SIGNALS RESPONSES ####
func _on_target_reached(_pos: Vector2) -> void:
	path.remove_at(0)
	
	if not path.is_empty():
		target_changed.emit(path[0])


func _on_path_updated(pos_id: int) -> void:
	if not active or pos_id > 0: return


func _on_target_changed(_target: Vector2) -> void:
	pass
