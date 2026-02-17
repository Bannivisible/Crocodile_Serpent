extends Spell
class_name LightnngCageSpell


@export var max_lightning_sphere: int= 7

@onready var cage: Node2D = $Cage

@onready var collision_polygon_2d: CollisionPolygon2D = null
@onready var hit_box: HitBox = $Cage/HitBox

@onready var polygon_2d: Polygon2D = $Cage/Polygon2D

@onready var line_2d: Line2D = $Cage/Line2D

var points: Array[Vector2]
var lightning_sphere_array: Array[LightningSphere]= []

var cage_coll_shape: Node2D

#### BUILT-IN ####
func _ready() -> void:
	Events.object_dispawn.connect(_on_Event_object_dispawn)
	
	remove_child(cage)
	get_tree().root.get_child(0).add_child(cage)


#### LOGIC ####
func append_point() -> void:
	if points.size() >= max_lightning_sphere:
		_remove_first_point()
		_remove_first_lightning_sphere()
	
	var pos: Vector2= self.global_position
	points.append(pos)
	_sort_points()
	
	_update_all()


func _remove_first_lightning_sphere() -> void:
	lightning_sphere_array[0].queue_free()
	lightning_sphere_array.remove_at(0)


func _update_all() -> void:
	_update_point_colision_cage()
	_update_point_line_2d()
	_update_point_polygone_cage()


func _update_point_colision_cage() -> void:
	if points.size() < 2: return
	if points.size() == 2:
		
		cage_coll_shape = _create_segment_collision()
		hit_box.add_child(cage_coll_shape)
	
	elif points.size() == 3:
		if cage_coll_shape is CollisionShape2D:
			cage_coll_shape.queue_free()
		
		cage_coll_shape = _create_polygone_collision()
		hit_box.add_child(cage_coll_shape)
	
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
	var pos: Vector2= lightning_sphere_array[0].global_position
	
	points.erase(pos)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("bent_down"):
		print(hit_box.overlapping_hurt_box)
		print(hit_box.damage_inteval_timer)


#### SIGNALS RESPONSES ####

func _on_Event_object_dispawn(sphere: Node2D) -> void:
	if not sphere in lightning_sphere_array: return
	
	points.erase(sphere.global_position)
	_sort_points()
	_update_all()


func _on_spawn_projectile_state_projectile_spawn(projectile: Projectile) -> void:
	append_point()
	lightning_sphere_array.append(projectile)
