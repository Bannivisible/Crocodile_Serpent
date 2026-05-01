extends Node2D

@export var grid_size: int= 2
@export var square_size := Vector2.ONE * 200.0

@export var tw_ease: Tween.EaseType
@export var tw_trans: Tween.TransitionType
@export var tw_time: float= 1.0

var h_lines_2d_array: Array[Line2D]= []
var static_bodies_array: Array[StaticBody2D]= []
var v_lines_2d_array: Array[Line2D]= []

var h_line_lenght: float:
	set = _set_h_line_lenght
var v_line_lenght: float:
	set = _set_v_line_lenght

var h_tween: Tween
var v_tween: Tween

#### SETTER ####
func _set_h_line_lenght(value: float) -> void:
	h_line_lenght = value
	
	for i in range(len(h_lines_2d_array)):
		_set_h_line_2d_lenght(h_lines_2d_array[i], h_line_lenght)
		#_update_static_body_coll_lenght(static_bodies_array[i])


func _set_v_line_lenght(value: float) -> void:
	v_line_lenght = value
	
	for line_2d in v_lines_2d_array:
		_set_v_line_2d_lenght(line_2d, v_line_lenght)


#### BUILT-IN ####
func _ready() -> void:
	set_as_top_level(true)
	_innit_grid()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"):
		_tween_h_lenght()
		_tween_v_lenght()


#### LOGIC ####
func _innit_grid() -> void:
	for i in range(grid_size):
		h_lines_2d_array.append(_innit_h_lines_2d(i))
		static_bodies_array.append(_init_static_body(i))
		v_lines_2d_array.append(_innit_v_lines_2d(i))


func _innit_h_lines_2d(line: int) -> Line2D:
	var line_2d := Line2D.new()
	
	var start: Vector2= _get_h_point_start(line)
	line_2d.points = [start, start]
	
	add_child(line_2d)
	
	return line_2d


func _init_static_body(line: int) -> StaticBody2D:
	var static_body := StaticBody2D.new()
	
	static_body.add_child(_innit_static_body_collision(line))
	
	static_body.set_collision_layer_value(1, false)
	static_body.set_collision_layer_value(
		Game.COLLISION_MASK.GROUND, true)
	static_body.set_collision_mask_value(
		Game.COLLISION_MASK.CHARACTER, true)
	
	h_lines_2d_array[line].add_child(static_body)
	
	return static_body


func _innit_static_body_collision(line: int) -> CollisionShape2D:
	var collision_shape := CollisionShape2D.new()
	collision_shape.one_way_collision = true
	
	var shape := SegmentShape2D.new()
	shape.a = _get_h_point_start(line)
	shape.b = shape.a
	collision_shape.shape = shape
	
	return collision_shape


func _innit_v_lines_2d(collumn: int) -> Line2D:
	var line_2d := Line2D.new()
	
	var start: Vector2= _get_v_point_start(collumn)
	line_2d.points = [start, start]
	
	add_child(line_2d)
	
	return line_2d


func _get_h_point_start(line: int) -> Vector2:
	return Vector2.DOWN * square_size * line


func _get_h_point_arrival(line2d: Line2D) -> Vector2:
	var start: Vector2= line2d.points[0]
	return start + Vector2.RIGHT * square_size * float(grid_size)


func _get_v_point_start(line: int) -> Vector2:
	return Vector2.RIGHT * square_size * line


func _get_v_point_arrival(line2d: Line2D) -> Vector2:
	var start: Vector2= line2d.points[0]
	return start + Vector2.DOWN * square_size * float(grid_size)


func _set_h_line_2d_lenght(line_2d: Line2D ,lenght: float) -> void:
	line_2d.points[1] = line_2d.points[0] + Vector2.RIGHT * lenght


func _update_static_body_coll_lenght(static_body: StaticBody2D) -> void:
	var collision_shape: CollisionShape2D= static_body.get_child(0)
	var shape: SegmentShape2D= collision_shape.shape
	var line_2d := _get_static_body_corresponding_line_2d(static_body)
	
	shape.b = line_2d.points[1]


func _set_v_line_2d_lenght(line_2d: Line2D, lenght: float) -> void:
	line_2d.points[1] = line_2d.points[0] + Vector2.DOWN * lenght


func _get_static_body_corresponding_line_2d(static_body: StaticBody2D) -> Line2D:
	return static_body.get_parent()


func _tween_h_lenght() -> void:
	var lenght: float= float(grid_size) * square_size.x
	h_tween = Utiles.reset_tween(self, h_tween, tw_ease, tw_trans)
	h_tween.tween_property(self, "h_line_lenght", lenght, tw_time)


func _tween_v_lenght() -> void:
	var lenght: float= float(grid_size) * square_size.y
	v_tween = Utiles.reset_tween(self, v_tween, tw_ease, tw_trans)
	v_tween.tween_property(self, "v_line_lenght", lenght, tw_time)
