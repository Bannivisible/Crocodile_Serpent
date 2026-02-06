extends Component
class_name StatisticsManager

@export var statistiques: Statistics

func _ready() -> void:
	statistiques.update_all_stat()
	
	var hp: HealthComponent= object.get_node_or_null("HealthComponent")
	if hp:
		hp.stat = statistiques
	
	var vel_comp: VelocityComponent= object.get_node_or_null("VelocityComponent")
	if vel_comp: vel_comp.charac_stat = statistiques
