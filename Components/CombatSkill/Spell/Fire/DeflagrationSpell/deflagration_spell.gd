extends Spell
class_name DeflagrationSpell

var current_projectile: ProjectileDeflagration

#### BUILT-IN ####
#func _ready() -> void:
	#Events.object_dispawn.connect(_on_Events_object_dispawn)

#### LOGIC ####
func cast_projectile() -> void:
	if current_projectile: current_projectile.cast()


func can_cast_projectile() -> bool:
	if current_projectile == null: return false
	return current_projectile.can_cast()


#### SIGNALS RESPONSES ####
func _on_spawn_projectile_state_projectile_spawn(projectile: Projectile) -> void:
	current_projectile = projectile



#func _on_Events_object_dispawn(node: Node2D) -> void:
	#print(current_projectile == null)
	#print(node)
	#if current_projectile == node:
		#current_projectile = null
