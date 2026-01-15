extends Resource
class_name CharcStatistics

@export var health: float
@export var strenght: float
@export var defense: float
@export var speed: float

enum STATS{
	HEALTH,
	STARDUST,
	STRENGHT,
	DEFENSE,
	SPEED,
}

var statistics: Dictionary[String, float]:
	get =  get_statistics

#class Buff:
	#var stat: STATS
	#var type: BUFFS_TYPES
	#
	#func _init(_stat: STATS, _type: BUFFS_TYPES) -> void:
		#stat = _stat
		#type = _type

var add_buffs: Array[Buff]
var mult_buffs: Array[Buff]

func get_statistics() -> Dictionary[String, float]:
	return {
		"health" = health,
		"strenght" = strenght,
		"defense" = defense,
		"speed" = speed }

func append_buff(buff: Buff) -> void:
	pass

func _add_buff(stat: StringName, amount: Variant) -> void:
	set(stat, amount)
