extends Component
class_name CombatSkill

@export var charac_stat: CharacStatistics:
	set(value):
		if value != charac_stat:
			charac_stat = value
			charac_stat_changed.emit(charac_stat)


signal charac_stat_changed(charac_stat: CharacStatistics)

func immobilize_player() -> void:
	if object is Crocodile:
		object.immobilize()


func free_player() -> void:
	if object is Crocodile:
		object.free_immobolize()
