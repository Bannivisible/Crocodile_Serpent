extends Resource
class_name BuffStat

@export var stat: Stat.STATS

@export var value: float

@export_enum("ADD", "MULTIPLY") var apply_type= "MULTIPLY"

@export var desactivation_condition: Condition
