extends Node2D
class_name Arena

var character_spawn_point_list: Array[CharacterSpawnPoint]

@onready var limit_rect: ReferenceRect = $UI/LimitRect

class CharacterSpawnPoint:
	var character: Character
	var spawn_point: Vector2
	
	func _init(_character) -> void:
		character = _character
		spawn_point = _find_spawn_point()
	
	func _find_spawn_point() -> Vector2:
		var ray_cast = RayCast2D.new()
		ray_cast.set_collision_mask_value(1, false)
		ray_cast.set_collision_mask_value(2, true)
		character.add_child(ray_cast)
		ray_cast.target_position.y = ProjectSettings.get_setting("display/window/size/viewport_height")
		ray_cast.force_raycast_update()
	
		if ray_cast.is_colliding():
			var new_point = ray_cast.get_collision_point()
			ray_cast.queue_free()
			return new_point
		else :
			push_warning("The RayCast2d not find a position to the ground at position " + str(character.global_position) + "for " + character.name)
			ray_cast.queue_free()
			return character.global_position

#### BUILT-IN ####

func _ready() -> void:
	for i in range(len(get_tree().get_nodes_in_group("Character"))):
		var character: Character = get_tree().get_nodes_in_group("Character")[i]
		_append_character_spawn_point(character)
		return_to_spawn_position(character)
	
	_init_limit_zone()
	_init_void_zone()

#### LOGIC ####

func _append_character_spawn_point(character: Character) -> void:
	character_spawn_point_list.append(CharacterSpawnPoint.new(character))

func _find_character_index(character: Character) -> int:
	for i in range(len(character_spawn_point_list)):
		if character_spawn_point_list[i].character == character:
			return i
	push_error("_find_character_index not found the index of " + character.name + " in character_spawn_point_list")
	return -1

func _find_spawn_position(character: Character) -> Vector2:
	var charac_spawn_pts_id = _find_character_index(character)
	return character_spawn_point_list[charac_spawn_pts_id].spawn_point

func return_to_spawn_position(character: Character) -> void:
	#var actual_pos = character.global_position
	var spawn_pos: Vector2 = _find_spawn_position(character)
	character.global_position = spawn_pos

func _init_limit_zone() -> void:
	var lenght: float= limit_rect.size.y
	create_wall(Vector2.ZERO, lenght)
	
	var pos: Vector2= Vector2.RIGHT * limit_rect.size.x
	create_wall(pos, lenght)

func _init_void_zone() -> void:
	var pos := Vector2(0.0, limit_rect.size.y)
	var lenght: float= limit_rect.size.x
	
	create_void(pos, lenght)

func create_wall(pos: Vector2, lenght: float, width := 1.0, rot:= 0.0) -> void:
	var wall := StaticBody2D.new()
	wall.set_collision_layer_value(1, false)
	wall.set_collision_layer_value(2, true)
	wall.set_collision_mask_value(1, true)
	wall.global_position = pos
	
	var collision := CollisionShape2D.new()
	var shape: Shape2D
	
	if width == 1.0:
		shape = SegmentShape2D.new()
		shape.b.y = lenght
	else :
		shape = RectangleShape2D.new()
		shape.size = Vector2(lenght, width)
	
	collision.shape = shape
	wall.add_child(collision)
	wall.rotation = rot
	
	add_child(wall)

func create_void(pos: Vector2, lenght: float, width := 1.0, rot:= 0.0) -> void:
	var void_zone := Area2D.new()
	
	void_zone.body_entered.connect(_on_void_zone_area_body_entered)
	
	void_zone.set_collision_mask_value(2, false)
	void_zone.global_position = pos
	
	var collision := CollisionShape2D.new()
	var shape: Shape2D
	
	if width == 1.0:
		shape = SegmentShape2D.new()
		shape.b.x = lenght
	else :
		shape = RectangleShape2D.new()
		shape.size = Vector2(lenght, width)
	
	collision.shape = shape
	void_zone.add_child(collision)
	void_zone.rotation = rot
	
	add_child(void_zone)

func _on_void_zone_area_body_entered(body: PhysicsBody2D) -> void:
	_fall_in_void_tween_animation(body)

func _fall_in_void_tween_animation(body: PhysicsBody2D) -> void:
	var void_tween := create_tween()
	var body_scale = body.scale
	
	void_tween.tween_property(body, 'scale', Vector2.ZERO, 1.0)
	void_tween.parallel().tween_property(body, 'rotation', TAU, 1.0)
	
	void_tween.tween_callback(func():
		body.scale = body_scale
		if body is Character:
			return_to_spawn_position(body))
