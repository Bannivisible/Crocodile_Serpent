extends Action
class_name ActionSpawnProjectile

@export var attack_data: AttackData

@export var projectile_scene: PackedScene

var factory: ProjectileFactory
@export_range(1, 99) var pool_size: int = 1
var factory_added: bool= false

@export var gap: Vector2= Vector2(50, -50)
@export var projectile_rotation: float= 0.0

@export var current_projectile_key: String= "current_projectile"
@export var factory_key: String= "factory"

func execute(_delta: float, owner: Node= null, component: Node= null, _manager: Node= null, context: Dictionary= {}) -> void:
	_add_factory(owner, component, context)
	
	var side= _get_projectile_side(owner)
	var rotation= _get_projectile_rotation(owner, component)
	
	var scale= component.global_scale
	var position = owner.global_position + Vector2(gap.x * side, gap.y)
	
	factory.spawn_instance(position , rotation, scale)
	context[current_projectile_key] = factory.get_last_instance()



func _add_factory(owner: Node, component: CombatSkill, context: Dictionary) -> void:
	if factory_added: return
	
	var faction: HealthComponent.FACTIONS = _get_projectile_faction(owner)
	
	factory = ProjectileFactory.new(
		projectile_scene, pool_size, attack_data, faction, component
	)
	
	context[factory_key] = factory
	
	owner.get_tree().current_scene.get_child(0).add_child(factory)
	factory_added = true

func _get_projectile_faction(owner: Node2D) -> HealthComponent.FACTIONS:
	var health_component: HealthComponent= owner.get_node_or_null("HealthComponent")
	
	if health_component: return health_component.faction
	else : return HealthComponent.FACTIONS.NEUTRAL

func _get_projectile_rotation(owner: Node2D, component: Node2D) -> float:
	var rotation = component.rotation
	
	var velocity_component : VelocityComponent= owner.get_node_or_null("VelocityComponent")
	if VelocityComponent:
		var face_dir: float= velocity_component.facing_direction.x
		if face_dir == -1.0: rotation += PI
	
	return rotation

func _get_projectile_side(owner: Node) -> float:
	var velocity_component : VelocityComponent= owner.get_node_or_null("VelocityComponent")
	if VelocityComponent:
		return velocity_component.facing_direction.x
	return 1.0
