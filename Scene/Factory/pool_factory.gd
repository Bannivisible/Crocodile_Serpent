extends Node
class_name PoolFactory

@export var object_scene: PackedScene:
	set(value):
		if value != object_scene:
			object_scene = value
			_init_pool()

@export_range(0, 99) var pool_size: int = 1

var pool: Array[Node2D] = []
var active_instance: Array[Projectile] = []

#### BUILT-IN ####

func _init(_object_scene: PackedScene, _pool_size: int) -> void:
	object_scene = _object_scene
	pool_size = _pool_size
	
	if object_scene == null:
		push_warning("PoolFactory: 'object_scene' is empty!")
	else :
		_init_pool()

#### LOGICS ####
func _init_pool() -> void:
	if pool != []: pool = []
	if active_instance != []: active_instance = []
	for i in range(pool_size):
		var instance: Node2D= object_scene.instantiate()
		add_child(instance)
		desactivate_instance(instance)
		
		pool.append(instance)

func desactivate_instance(instance: Node2D) -> void:
	instance.visible = false
	instance.set_physics_process(false)
	instance.set_block_signals(true)
	
	if instance in active_instance: active_instance.erase(instance)
	
	if instance.has_method("desactivate") and instance.is_node_ready(): 
		instance.desactivate()

func _activate_instance(instance: Node2D) -> void:
	instance.visible = true
	instance.set_physics_process(true)
	instance.set_block_signals(false)
	
	active_instance.append(instance)
	
	if instance.has_method("activate") and instance.is_node_ready():
		instance.activate()

func spawn_instance(pos: Vector2, rot: float= 0.0, scale := Vector2.ONE ) -> void:
	if pool_size == active_instance.size() : return
	
	var instance = _get_first_free_instance()
	if instance == null: return
	
	instance.global_position = pos
	instance.rotation = rot 
	instance.scale = scale
	
	_activate_instance(instance)

func _get_first_free_instance() -> Node2D:
	for instance in pool:
		if instance in active_instance:
			continue
		return instance
		
	return null

func get_instance(index: int) -> Projectile:
	if active_instance.size() <= index or active_instance.size() <= 0: return 
	return active_instance[index]

func get_last_instance() -> Projectile:
	if active_instance.size() <= 0: return
	return active_instance[len(active_instance) - 1]

func get_first_instance() -> Projectile:
	if active_instance.size() <= 0: return
	return active_instance[0]
