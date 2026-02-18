extends ProjectileFireBall
class_name ProjectileDeflagration

@export_range(0.0, 5.0, 0.01) var p_ratio: float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D

var damage_min: float = 50.0


func _compute_dist_damage(area: Node2D, damage: float) -> float:
	var distance: float= global_position.distance_to(area.global_position)
	var rayon: float= collision_shape_2d.shape.radius
	
	return damage * max(damage_min, 1.0 - (distance/rayon)**p_ratio)


func cast() -> void:
	state_machine.set_state_with_string("LinearMovement")


func _disapear() -> void:
	pass

### SIGNAL RESPONSES ####
#func _on_area_2d_entered(area: Area2D) -> void:
	#super._on_area_2d_entered(area)
	#
	#var hurt_box: HurtBox= area
	#if hurt_box.owner.faction == faction: return
	#var raw_damage: float= _compute_raw_damage()
	#var damage: float= _compute_damage(area, raw_damage)
	#
	#hurt_box.hurt(damage, self)


func _on_LinearMovement_destination_reached() -> void:
	state_machine.set_state_with_string("Explode")

