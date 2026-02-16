extends HitBox


@export var spell: Spell= owner


func _compute_raw_damage() -> float:
	var raw_damage: float= spell.stat.power + attack_data.add_damage
	raw_damage *= attack_data.mult_damage
	return raw_damage
