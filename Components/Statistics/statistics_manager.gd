extends Component
class_name StatisticsManager

@export var statistiques: Statistics

func _ready() -> void:
	statistiques.update_all_stat()
	
	var hp: HealthComponent= object.get_node_or_null("HealthComponent")
	if hp:
		hp.stat = statistiques
	
	var bmc: BMC= object.get_node_or_null("BMC")
	if bmc: bmc.charac_stat = statistiques
