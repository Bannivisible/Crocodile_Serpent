extends Area2D
class_name HurtBox

@export var damage_multiplier: float= 1.0

@export var resistances: Array[ResistanceType]

signal hitted(damage: float, hurt_box: HurtBox, hit_box: HitBox)

var curr_add_res_mult: float= 0.0

func _ready() -> void:
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, false)

func hurt(raw_damage: float, hit_box: HitBox) -> void:
	var damage = _compute_damage(raw_damage, hit_box.attack_data.type)
	hitted.emit(damage, self, hit_box)

func _compute_damage(damage: float, type: AttackType) -> float:
	var resistance_add_multiplier: float= 0.0
	for i in range(resistances.size()):
		resistance_add_multiplier += _compute_resistance(type, resistances[i])
	
	curr_add_res_mult = resistance_add_multiplier
	
	return damage * (damage_multiplier + curr_add_res_mult)

func _modify_label_damage(label: Label) -> Label:
	var label_settings: LabelSettings= label.label_settings
	
	if curr_add_res_mult < 1:
		label_settings.add_stacked_shadow()
		var id: int= label_settings.stacked_shadow_count - 1
		label_settings.set_stacked_shadow_color(id, Color(0.0, 0.0, 1.0, 1.0))
		label_settings.set_stacked_shadow_offset(id, Vector2.ONE * 2)
	
	elif curr_add_res_mult > 1:
		label_settings.add_stacked_shadow()
		var id: int= label_settings.stacked_shadow_count - 1
		label_settings.set_stacked_shadow_color(id, Color(1.0, 0.0, 0.0, 1.0))
		label_settings.set_stacked_shadow_offset(id, Vector2.ONE * 2)
	
	return label

func _compute_resistance(attack_type: AttackType, res_type: ResistanceType) -> float:
	var result: float= 0.0
	
	var bit_atck: int= attack_type.type if attack_type else 0
	var bit_res: int= res_type.type.type 
	var bit := 1
	
	for i in range(Utiles.count_bits(bit_res)):
		if bit_atck & bit != 0 and bit_res & bit != 0:
			result += res_type.multiplier
	return result
