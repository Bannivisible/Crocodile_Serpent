extends WeaponAttackState

@export_range(0.0, 999.9) var bonus_time_amount: float= 1.0

@onready var dynamic_timer: DynamicTimer = $"../DynamicTimer"

func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	super._on_hit_box_hit(_damage, _hurt_box)
	
	if hit_box.attack_data == attack_data:
		dynamic_timer.add_time(bonus_time_amount)
