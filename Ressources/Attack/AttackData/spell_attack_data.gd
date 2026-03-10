extends AttackData
class_name SpellAttackData


func _get_raw_damage(charac_stat: CharacStatistics ,cs_stat: Statistics) -> float:
	var spell_stat: SpellStatistics= cs_stat
	return spell_stat.power + super._get_raw_damage(charac_stat, cs_stat)
