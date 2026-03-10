extends Resource
class_name AttackData

@export var mult_damage: float= 1.0

@export var add_damage: float

@export var type: AttackType


func _get_raw_damage(charac_stat: CharacStatistics ,_cs_stat: Statistics) -> float:
	if charac_stat: return charac_stat.strenght + add_damage
	else : return add_damage


func compute_damage(charac_stat: CharacStatistics ,_cs_stat: Statistics) -> float:
	var damage: float= _get_raw_damage(charac_stat, _cs_stat) * mult_damage
	return damage


func modify_label_damage(_label: Label) -> void:
	return
