extends Component
class_name VelocityComponent

const MULT_SPEED: float= 10.0
const MIN_SPEED: float= 0.05

@export var charac_stat: CharacStatistics

@export var suffer_gravity: bool= true
@export var gravity: float = 3000.0

@onready var character: Character= object

@onready var scale_x_face_inverser: ScaleXFaceInverser = $ScaleXFaceInverser
@onready var pos_x_face_inverser: PosXFaceInverser = $PosXFaceInverser
@onready var rotation_leader: RotationLeader = $RotationLeader


var face_dir := Vector2.RIGHT:
	set(value):
		if value != face_dir:
			face_dir = value
			face_dir_changed.emit(face_dir)

var dir: Vector2:
	set(value):
		if value != dir:
			dir = value
			dir_changed.emit(dir)


var path: Array[Vector2]

var speed: float:
	get: return charac_stat.speed

var follow_target: bool= false
var follow_path: bool= false


signal dir_changed(dir: Vector2)
signal face_dir_changed(face_dir: Vector2)

signal target_reached(pos: Vector2)
signal target_changed(pos: Vector2)

#### BUILT-IN ####
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	_move_along_path(delta)
	character.move_and_slide()
	
	if not character.is_on_floor() and suffer_gravity:
		apply_gravity(delta)


### SETTER ###
func _set_charac_stat(value: CharacStatistics) -> void:
	if charac_stat != null:
		charac_stat.stat_updated.disconnect(_on_charac_stat_stat_updated)
	
	charac_stat = value
	
	if charac_stat != null:
		charac_stat.stat_updated.connect(_on_charac_stat_stat_updated)


### GETTER ###
func get_current_target() -> Vector2:
	if path.is_empty(): return Vector2.ZERO
	
	return path[0]


#### LOGIC ####
func _move_along_path(delta: float) -> void:
	if path.is_empty(): return
	
	var target: Vector2= path[0]
	var dist: float= character.global_position.distance_to(target)
	
	if dist < speed * MULT_SPEED * delta:
		character.global_position = target
		target_reached.emit(target)


func _direct_to(target: Vector2) -> void:
	dir = character.global_position.direction_to(target)


func update_velocity() -> void:
	character.velocity = dir * speed * MULT_SPEED


func update_velocity_x() -> void:
	character.velocity.x = dir.x * speed * MULT_SPEED


func roatate_dir_to(pos: Vector2) -> void:
	dir = character.global_position.direction_to(pos)


func walk_to(pos: Vector2) -> void:
	var direction: Vector2= character.global_position.direction_to(pos)
	if sign(direction.x) == 1: direction =  Vector2.RIGHT
	else : direction = Vector2.LEFT
	
	dir = direction


func add_target_at_begining(target: Vector2) -> void:
	path.push_front(target)
	target_changed.emit(target)


func add_target_at_end(target: Vector2) -> void:
	path.append(target)
	
	if len(path) == 1: target_changed.emit(target)


func apply_gravity(delta: float) -> void:
	character.velocity.y += gravity * delta


func jump(force: float) -> void:
	character.velocity.y -= force


func reset_air_velocity() -> void:
	character.velocity.y = 0.0


func immobilize() -> void:
	pass


func free_immobilize() -> void:
	pass


#### SIGNAL RESPONSES ####
func _on_dir_changed(_dir: Vector2) -> void:
	if dir.x != 0.0:
		face_dir.x = sign(dir.x)


func _on_charac_stat_stat_updated() -> void:
	update_velocity_x()


func _on_target_reached(_pos: Vector2) -> void:
	path.remove_at(0)
	
	if not path.is_empty():
		target_changed.emit(path[0])

