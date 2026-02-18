extends AttackData
class_name SpellAttackData


func compute_damage(cs_stat: Statistics) -> float:
	var spell_stat: SpellStatistics= cs_stat
	
	return (spell_stat.power + add_damage) * mult_damage 
