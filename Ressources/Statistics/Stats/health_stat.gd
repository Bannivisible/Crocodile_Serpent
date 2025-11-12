extends Stat
class_name HealthStat

var stat := STATS.HEALTH

signal die()

var current_health: float= value:
	set(val):
		if val != current_health:
			current_health = clamp(val, 0.0, value)
			
			if current_health <= 0.0:
				die.emit()
