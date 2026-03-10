extends AttackData
class_name WeaponAttackData

@export var mult_crit_rate: float= 1.0
@export var add_crit_rate: float

@export var mult_crit_coef: float= 1.0
@export var add_crit_coef: float


var current_is_crit: bool

func _get_raw_damage(charac_stat: CharacStatistics ,cs_stat: Statistics) -> float:
	var weapon_stat: WeaponStatistics= cs_stat
	
	return weapon_stat.attack + super._get_raw_damage(charac_stat, cs_stat)


func compute_damage(charac_stat: CharacStatistics ,cs_stat: Statistics) -> float:
	if cs_stat == null: return super.compute_damage(charac_stat ,cs_stat)
	
	var weapon_stat: WeaponStatistics= cs_stat
	var damage: float= _get_raw_damage(charac_stat, cs_stat) * mult_damage
	
	current_is_crit = _is_critical(cs_stat)
	
	if current_is_crit:
		var crit_coef: float= weapon_stat.crit_coef + add_crit_coef
		crit_coef *= mult_crit_coef
		damage *= crit_coef
	
	return damage


func _is_critical(weapon_stat: WeaponStatistics) -> bool:
	var total_crit: float= (weapon_stat.crit_rate + add_crit_rate) * mult_crit_rate
	
	return total_crit > randf()


func modify_label_damage(label: Label) -> void:
	if not current_is_crit: return
	
	var label_settings: LabelSettings= label.label_settings
	label_settings.add_stacked_shadow()
	var id: int= label_settings.stacked_shadow_count - 1
	label_settings.set_stacked_shadow_color(id, Color(1.0, 1.0, 0.0, 1.0))
	label_settings.set_stacked_shadow_offset(id, Vector2.ONE * 3)
	label_settings.font_size = int(label_settings.font_size * 1.5)
