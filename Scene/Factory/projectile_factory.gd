extends PoolFactory
class_name ProjectileFactory

var attack_data: AttackData
var faction: HealthComponent.FACTIONS
var cs: CombatSkill

func _init(_object_scene: PackedScene, _pool_size: int, _attack_data: AttackData, _faction := HealthComponent.FACTIONS.NEUTRAL, _cs: CombatSkill= null) -> void:
	attack_data = _attack_data
	faction = _faction
	cs = _cs
	
	super._init(_object_scene, _pool_size)

func _activate_instance(instance: Node2D) -> void:
	var projectile: Projectile= instance
	super._activate_instance(projectile)
	projectile.monitoring = true

func desactivate_instance(instance: Node2D) -> void:
	var projectile: Projectile= instance
	super.desactivate_instance(projectile)
	projectile.monitoring = false

func _init_pool() -> void:
	if pool != []: pool = []
	if active_instance != []: active_instance = []
	for i in range(pool_size):
		var projectile: Projectile= object_scene.instantiate()
		
		if cs: projectile.cs = cs
		if attack_data: projectile.attack_data = attack_data
		projectile.faction = faction
		
		add_child(projectile)
		desactivate_instance(projectile)
		
		pool.append(projectile)
