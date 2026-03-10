extends Projectile
class_name WindSphereProjectile

@export var rotation_amount: float= PI


func _physics_process(delta: float) -> void:
	rotation += delta * rotation_amount
