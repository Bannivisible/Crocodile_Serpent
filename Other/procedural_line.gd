@tool
extends Line2D
class_name ProceduralLine

@export var reinitialize: bool= false:
	set = reinitialized
func reinitialized(value: bool) -> void:
	if value == true:
		_init_points()
		queue_redraw()

@export var anchor_path: NodePath= "..":
	set = set_anchor
@onready var anchor: Node2D= get_node(anchor_path)
func set_anchor(value: NodePath) -> void:
	anchor_path = value
	anchor =get_node(value)

@export_group("Parameters")

@export var distance: float:
	set(value):
		if value != distance:
			distance = value
			_init_points()

@export var init_dir:= Vector2.RIGHT

@export var collide: bool= true
@export_subgroup("Collision", "collision")
@export var collision_mask: Game.COLLISION_MASK= Game.COLLISION_MASK.GROUND

@export var get_gravity: bool= true
@export_subgroup("Gravity", "gravity")
@export var gravity_amount: float= 100.0
@export var gravity_increase_amount: float= 0.0

@export_group("Visuals")
@export var outline_color: Color
@export var outline_width: float

##### BUILT-IN ####
func _ready() -> void:
	_init_points()
	
	if not Engine.is_editor_hint(): Utiles.add_child_to_root(self)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if get_gravity: _process_gravity(delta)
	if collide: _process_collisions()
	_process_points()

#### LOGIC ###

func _init_points() -> void:
	if not anchor: return
	
	for i in range(points.size()):
		var anchor_pos = Vector2.ZERO if Engine.is_editor_hint() else anchor.global_position 
		var pos: Vector2= anchor_pos + init_dir * distance * i
		points[i] = pos

func _process_points() -> void:
	if points.size() == 0 or anchor == null: return
	
	points[0] = anchor.global_position
	
	for i in range(1, points.size()):
		var dist: Vector2= points[i] - points[i-1]
		
		dist = dist.limit_length(distance)
		
		points[i] = points[i-1] + dist

func _process_gravity(delta: float) -> void:
	for i in range(1, points.size()):
		var gravity = Vector2.DOWN * (gravity_amount + gravity_increase_amount * i) * delta
		
		gravity.limit_length(distance)
		
		points[i] += gravity

func _process_collisions() -> void:
	var space_state: PhysicsDirectSpaceState2D= get_world_2d().direct_space_state
	
	for i in range(points.size()):
		var point_widht: float= _get_point_widht(i)
		var to: Vector2 = points[i] + Vector2.DOWN * point_widht
		var ray_query := PhysicsRayQueryParameters2D.create(
			points[i], to, collision_mask)
		
		var collision: Dictionary= space_state.intersect_ray(ray_query)
		
		if collision:
			points[i] = collision["position"] +  Vector2.UP * point_widht

func _get_point_widht(pos_id: int) -> float:
	var width_pos: float= float(pos_id) / float(points.size())
	
	var result: float= width * width_curve.sample(width_pos)
	
	return result / 2

#func _draw() -> void:
	#var pos_point: Array[Vector2]
	#for i in range(points.size()):
		#var pos: Vector2= _get_pos_for_outline(i)
		#pos_point.append(pos)
	#
		#draw_multiline(pos_point, outline_color, outline_width)
#
#func _get_pos_for_outline(pos_id: int) -> Vector2:
	#if pos_id == points.size()-1: return points[pos_id]
	#
	#var dir: Vector2= points[pos_id] - points[pos_id + 1]
	#dir = dir.normalized()
	#var normal := Vector2(-dir.y, dir.x)
	#
	#var pos: Vector2= points[pos_id] + normal * _get_point_widht(pos_id)
	#return pos
