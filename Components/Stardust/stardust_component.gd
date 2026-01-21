extends Component
class_name StardustComponent

@export var wizard_stat: Wizard_statistics

var stardust: float:
	get: return wizard_stat.stardust

func aubdu(s: SpellStatistics):
	stardust < s.stardust_cost
