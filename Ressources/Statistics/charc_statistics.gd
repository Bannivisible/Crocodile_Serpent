extends Statistics
class_name CharcStatistics

@export var base_max_health: float
@export var base_strenght: float
@export var base_defense: float
@export var base_speed: float

var max_health: float
var strenght: float
var defense: float
var speed: float

func get_statistics() -> Dictionary[String, float]:
	return {
		"max_health" = max_health,
		"strenght" = strenght,
		"defense" = defense,
		"speed" = speed }
