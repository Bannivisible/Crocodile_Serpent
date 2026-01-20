extends Component
class_name StatisticsManager

@export var statistiques: Statistics

@export var buff: Buff

func _ready() -> void:
	statistiques.update_all_stat()
	
	var hp: HealthComponent= object.get_node_or_null("HealthComponent")
	if hp:
		hp.stat = statistiques
	
	var bmc: BMC= object.get_node_or_null("BMC")
	if bmc: bmc.charac_stat = statistiques

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("special"):
		statistiques.append_buff(buff)
	
	if Input.is_action_just_pressed("BentDown"):
		statistiques.remove_buff(buff)
