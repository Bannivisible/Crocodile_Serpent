extends Spell
class_name SpellLightnngCage

@onready var cage: Node2D = $Cage

@onready var collision_polygon_2d: CollisionPolygon2D = null
@onready var hit_box: HitBox = $Cage/HitBox

@onready var polygon_2d: Polygon2D = $Cage/Polygon2D

@onready var line_2d: Line2D = $Cage/Line2D

var points: Array[Vector2]

var lightning_sphere_signals_connected := false

func _ready() -> void:
	remove_child(cage)
	get_tree().root.get_child(0).add_child(cage)

func append_point() -> void:
	if not lightning_sphere_signals_connected: _connect_sphere_disapear()
	
	if context.has("factory"):
		var factory: ProjectileFactory= context["factory"]
		if points.size() >= factory.pool_size:
			_remove_first_point()
			_remove_first_lightning_sphere()
	
	var pos: Vector2= self.global_position
	points.append(pos)
	_sort_points()
	
	_update_all()

func _remove_first_lightning_sphere() -> void:
	var factory: ProjectileFactory= context["factory"]
	var first_sphere: LightningSphere= factory.active_instance[0]
	factory.desactivate_instance(first_sphere)

func _update_all() -> void:
	_update_point_colision_cage()
	_update_point_line_2d()
	_update_point_polygone_cage()

func _update_point_colision_cage() -> void:
	if points.size() < 2: return
	if points.size() == 2:
		if hit_box.get_child_count() == 1: hit_box.get_child(0).queue_free()
		
		var collision = _create_segment_collision()
		hit_box.add_child(collision)
	
	elif points.size() == 3:
		if hit_box.get_child_count() == 1: hit_box.get_child(0).queue_free()
		
		var collision = _create_polygone_collision()
		hit_box.add_child(collision)
	
	else :
		collision_polygon_2d.polygon = points

func _create_segment_collision() -> CollisionShape2D:
		var collision := CollisionShape2D.new()
		var shape: = SegmentShape2D.new()
		shape.a = points[0]
		shape.b = points[1]
		collision.shape = shape
		return collision

func _create_polygone_collision() -> CollisionPolygon2D:
	collision_polygon_2d = CollisionPolygon2D.new()
	collision_polygon_2d.polygon = points
	
	return collision_polygon_2d

func _update_point_polygone_cage() -> void:
	polygon_2d.polygon = points

func _update_point_line_2d() -> void:
	line_2d.points = points

func _sort_points() -> void:
	var center = Vector2.ZERO
	for point in points:
		center += point
	center /= points.size()

	points.sort_custom(func(a, b):
		var angle_a = atan2(a.y - center.y, a.x - center.x)
		var angle_b = atan2(b.y - center.y, b.x - center.x)
		return angle_a < angle_b
	)

func _remove_first_point() -> void:
	if not context.has("factory"): return
	var factory: ProjectileFactory= context["factory"]
	var pos: Vector2= factory.get_first_instance().global_position
	
	points.erase(pos)

func _connect_sphere_disapear() -> void:
	if not context.has("factory"): return
	var factory: ProjectileFactory= context["factory"]
	
	for instance in factory.pool:
		var lightning_sphere: LightningSphere= instance
		lightning_sphere.disapear.connect(_on_lightning_sphere_disapear)
	
	lightning_sphere_signals_connected = true

func _on_lightning_sphere_disapear(sphere: LightningSphere) -> void:
	points.erase(sphere.global_position)
	_sort_points()
	_update_all()

#func _get_pos_id(pos: Vector2) -> int:
	#for i in points.size():
		#if pos == points[i]:
			#return i
	#return 0
