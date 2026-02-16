extends Spell
class_name DeflagrationSpell

var current_projectile: ProjectileDeflagration

#### BUILT-IN ####
#func _ready() -> void:
	#Events.object_dispawn.connect(_on_Events_object_dispawn)

#### SIGNALS RESPONSES ####
func _on_spawn_projectile_state_projectile_spawn(projectile: Projectile) -> void:
	current_projectile = projectile



#func _on_Events_object_dispawn(node: Node2D) -> void:
	#print(current_projectile == null)
	##if current_projectile == node:
		##current_projectile = null
