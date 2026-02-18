extends Resource
class_name AttackData

@export var mult_damage: float= 1.0

@export var add_damage: float

@export var type: AttackType

@warning_ignore("unused_parameter")
func compute_damage(cs_stat: Statistics) -> float:
	return add_damage * mult_damage


@warning_ignore("unused_parameter")
func modify_label_damage(label: Label) -> void:
	return
