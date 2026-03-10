extends Statistics
class_name SpellStatistics

@export var base_power: float
@export var base_stardust_cost: float
@export var base_duration: float

var power: float
var stardust_cost: float
var duration: float

func get_statistics() -> Dictionary[String, float]:
	return {
		"power": power,
		"stardust_cost": stardust_cost,
		"duration": duration
	}
