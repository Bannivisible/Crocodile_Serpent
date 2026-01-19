extends Component
class_name StatisticsManager

@export var statistiques: Statistics

func _ready() -> void:
	var hp: HealthComponent= object.get_node_or_null("HealthComponent")
	if hp:
		hp.stat = statistiques
	
	var bmc: BMC= object.get_node_or_null("BMC")
	if bmc: bmc.charc_stat = statistiques
