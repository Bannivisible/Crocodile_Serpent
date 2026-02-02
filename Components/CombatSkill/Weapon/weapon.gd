extends CombatSkill
class_name Weapon

@export var statistics: WeaponStatistics

func _ready() -> void:
	statistics.update_all_stat()
