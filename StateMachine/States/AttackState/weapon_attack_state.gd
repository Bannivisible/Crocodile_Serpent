extends AttackState
class_name WeaponAttackState

@export var weapon_attack_data: WeaponAttackData

func _obtain_hit_box_path() -> String:
	return "WeaponHitBox"

func _update_hit_box() -> void:
	super._update_hit_box()
	hit_box.weapon_attck_data = weapon_attack_data
