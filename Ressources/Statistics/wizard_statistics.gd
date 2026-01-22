extends CharacStatistics
class_name Wizard_statistics

@export var base_max_stardust: float

var max_stardust: float

func get_statistics() -> Dictionary[String, float]:
	var dict_stat := super.get_statistics()
	dict_stat["max_stardust"] = max_stardust
	
	return dict_stat

var stardust: float
