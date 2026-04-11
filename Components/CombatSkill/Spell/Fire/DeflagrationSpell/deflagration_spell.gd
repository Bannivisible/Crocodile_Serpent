extends Spell
class_name DeflagrationSpell

var current_projectile: ProjectileDeflagration

#### BUILT-IN ####

#### LOGIC ####
func cast_projectile() -> void:
	if current_projectile: current_projectile.cast()


func can_cast_projectile() -> bool:
	if current_projectile == null: return false
	return current_projectile.can_cast()


#### SIGNALS RESPONSES ####
func _on_spawn_projectile_state_projectile_spawn(projectile: Projectile) -> void:
	current_projectile = projectile

