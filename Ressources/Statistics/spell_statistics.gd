extends Statistics
class_name SpellStatistics

@export var base_power: float
@export var base_stardust_cost: float

var power: float
var stardust_cost: float

func get_statistics() -> Dictionary[String, float]:
	return {
		"power": power,
		"stardust_cost": stardust_cost
	}
