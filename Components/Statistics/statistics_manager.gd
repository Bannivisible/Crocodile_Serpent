extends Component
class_name StatisticsManager

@export var statistiques: Statistcs

func _physics_process(delta: float) -> void:
	statistiques.verif_buff_conditions(delta, object)

func _ready() -> void:
	var hp: HealthComponent= object.get_node_or_null("HealthComponent")
	if hp:
		hp.health = statistiques.health
		hp.defense = statistiques.defense
	
	var bmc: BMC= object.get_node_or_null("BMC")
	if bmc: bmc.speed = statistiques.speed
