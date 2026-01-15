extends Resource
class_name WeaponStatistics

@export var attack: float

@export_range(0.0, 100.0) var crit_rate: float
#Si dépasse 100, la puissance des coups critique augmente

@export var crit_mult: float= 1.0

