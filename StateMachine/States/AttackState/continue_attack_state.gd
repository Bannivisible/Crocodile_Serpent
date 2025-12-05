extends AttackState

@export_range(0.0, 60.0) var damage_inteval: float= 0.0

func _input(_event: InputEvent) -> void:
	super._input(_event)
	
	if _input_condition():
		state_machine.set_state_with_string(idle_state_name)

func _combo_logic() -> void:
	if not next_attack.is_combo_cooldown_running() and not is_attack_currently_playing():
		return
	
	if combo_condition_valid():
		state_machine.current_state = next_attack
