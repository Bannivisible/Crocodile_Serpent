extends ProjectileFireBall
class_name ProjectileDeflagration

@export_range(0.0, 5.0, 0.01) var p_ratio: float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explode: Node = $StateMachine/Explode

var damage_min: float = 50.0
var curr_hurt_box: HurtBox


func _compute_dist_damage(hurt_box: HurtBox) -> float:
	var damage: float= super._get_damage()
	
	var dist: float= global_position.distance_to(hurt_box.global_position)
	
	var ray: float= collision_shape_2d.shape.radius * 2.0
	ray *= scale.x
	
	damage *= 1.0 - (dist/ray) ** p_ratio
	return roundf(damage)


func _get_damage() -> float:
	if state_machine.get_state_name() == "Explode":
		return _compute_dist_damage(curr_hurt_box)
	
	return super._get_damage()


func can_cast() -> bool:
	return state_machine.get_state_name() == "Appear"


func cast() -> void:
	state_machine.set_state_with_string("LinearMovement")


### SIGNAL RESPONSES ####
func _on_area_2d_entered(area: Area2D) -> void:
	match state_machine.get_state_name():
		"LinearMovement":
			super._on_area_2d_entered(area)
		"Explode":
			if not _is_area_valid(area): return
			curr_hurt_box = area
			
			_affect_hurt_box(area)


func _on_LinearMovement_destination_reached() -> void:
	state_machine.set_state_with_string("Explode")
