extends Reactive
class_name Statistcs

@export var health: HealthStat
@export var stardust: StardustStat
@export var strenght: StrenghtStat
@export var defense: DefenseStat
@export var speed: SpeedStat

var statistics: Dictionary[String, Stat]:
	get: return get_statistics()

var buffs: Array[BuffStat]

func _init(initial_possessor : Reactive = null) -> void:
	super._init(initial_possessor)

func get_statistics() -> Dictionary[String, Stat]:
	return {
		"health" = health,
		"stardust" = stardust,
		"strenght" = strenght,
		"defense" = defense,
		"speed" = speed }

func _get_corresponding_stat(buff: BuffStat) -> Stat:
	for stat in statistics.values():
		if stat.stat == buff.stat:
			return stat
	return null

func apply_buff(buff: BuffStat) -> void:
	var stat = _get_corresponding_stat(buff)
	if !stat: return
	
	match buff.apply_type:
		"ADD": stat.value += buff.value
		"MULTIPLY": stat.append_multiplier(buff.value)
	
	buffs.append(buff)

func remove_buff(buff: BuffStat) -> void:
	var stat = _get_corresponding_stat(buff)
	if !stat: return
	
	match buff.apply_type:
		"ADD": stat.value -= buff.value
		"MULTIPLY": stat.append_multiplier(-buff.value)
	
	buffs.erase(buff)

func verif_buff_conditions(delta: float, owner=null, component=null, stardustger=null, context={}) -> void:
	for buff in buffs:
		if buff.desactivation_condition.is_valid(delta, owner, component, stardustger, context):
			remove_buff(buff)
