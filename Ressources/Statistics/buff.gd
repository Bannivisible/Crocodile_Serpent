extends Resource
class_name Buff

@export_enum("health", "strenght", "defense", "speed") var stat_name: String
@export var type: BUFFS_TYPES
@export var amount: float

enum BUFFS_TYPES{
	ADD,
	MULTIPLY
}
