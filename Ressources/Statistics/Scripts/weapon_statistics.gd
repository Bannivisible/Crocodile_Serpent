extends Statistics
class_name WeaponStatistics

@export var base_attack: float
@export_range(0.0, 100.0) var base_crit_rate: float
@export var base_crit_coef: float= 1.0

var attack: float
var crit_rate: float
var crit_coef: float= 1.0

func get_statistics() -> Dictionary[String, float]:
	return {
		"attack": attack,
		"crit_rate": crit_rate,
		"crit_coef": crit_coef
	}
