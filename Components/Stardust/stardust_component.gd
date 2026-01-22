extends Component
class_name StardustComponent

const STARDUST_STAT_NAME: String= "stardust"

@export var wizard_stat: Wizard_statistics

var stardust: float:
	get: return wizard_stat.stardust

func _ready() -> void:
	wizard_stat.update_all_stat()
	wizard_stat.set_variable_stat(STARDUST_STAT_NAME, wizard_stat.max_stardust)

func cast_spell(spell: Spell) -> void:
	wizard_stat.set_variable_stat("stardust", stardust - spell.stat.stardust_cost)
