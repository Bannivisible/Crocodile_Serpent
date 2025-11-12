@abstract
extends ReactiveFloat
class_name Stat

enum STATS{
	HEALTH,
	STARDUST,
	STRENGHT,
	DEFENSE,
	SPEED,
	CRITICAL_RATE
}

var buff_multiplier : float

func append_multiplier(multiplier: float) -> void:
	value /= buff_multiplier
	buff_multiplier += multiplier
	value *= buff_multiplier
