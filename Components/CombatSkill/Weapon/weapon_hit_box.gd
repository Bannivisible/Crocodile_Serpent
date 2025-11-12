extends HitBox
class_name WeaponHitBox

@export var weapon_attck_data: WeaponAttackData

var current_is_crit: bool= false

func _compute_raw_damage() -> float:
	var damage: float= super._compute_raw_damage()
	
	current_is_crit = _is_critical()
	if current_is_crit: damage *= 3
	
	return damage

func _is_critical() -> bool:
	var weapon: Weapon= cs
	var total_crit: float= weapon.critical_rate.value * weapon_attck_data.mult_crit_rate + weapon_attck_data.add_crit_rate.value
	
	return total_crit > randf()

func modify_label_damage(label: Label) -> void:
	if not current_is_crit: return
	
	var label_settings: LabelSettings= label.label_settings
	label_settings.add_stacked_shadow()
	var id: int= label_settings.stacked_shadow_count - 1
	label_settings.set_stacked_shadow_color(id, Color(1.0, 1.0, 0.0, 1.0))
	label_settings.set_stacked_shadow_offset(id, Vector2.ONE * 3)
	label_settings.font_size = int(label_settings.font_size * 1.5)
