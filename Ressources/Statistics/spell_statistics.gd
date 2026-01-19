extends Statistics
class_name SpellStatistics

@export var base_power: float
@export var base_stardust_cost: int

var power: float
var stardust_cost: int

func get_statistics() -> Dictionary[String, float]:
	return {
		"power": power,
		"stardust_cost": stardust_cost
	}
