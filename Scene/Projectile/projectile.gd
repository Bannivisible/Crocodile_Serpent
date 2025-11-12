@abstract
extends HitBox
class_name Projectile

@onready var factory: ProjectileFactory= _get_factory()

@abstract
func activate() -> void

@abstract
func desactivate() -> void

func _get_factory() -> ProjectileFactory:
	if factory != null: return factory
	if get_parent() is ProjectileFactory:
		return get_parent()
	return null
