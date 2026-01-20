extends Resource
class_name Buff

@export_enum("health", "strenght", "defense", "speed") var stat_name: String
@export var type: BUFFS_TYPES
@export var amount: float

enum BUFFS_TYPES{
	ADD,
	MULTIPLY
}

func _init(_stat_name: String= stat_name, _typre: BUFFS_TYPES= type, _amount: float= amount) -> void:
	stat_name = _stat_name
	type = _typre
	amount = _amount
