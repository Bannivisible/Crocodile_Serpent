@abstract
extends HitBox
class_name Projectile

@onready var factory: Factory= _get_factory()



func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		Events.object_dispawn.emit(self)


func _get_factory() -> Factory:
	if factory != null: return factory
	if get_parent() is Factory:
		return get_parent()
	return null
