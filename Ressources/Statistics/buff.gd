extends Resource
class_name Buff

@export var stat_name: StringName
@export var type: BUFFS_TYPES
@export var amount: float

enum BUFFS_TYPES{
	ADD,
	MULTIPLY
}
