extends State

@onready var free_move: BMC_FreeMoveState = $"../FreeMove"


func _on_bmc_dir_changed(dir: Vector2) -> void:
	if is_current_state() and dir != Vector2.ZERO:
		state_machine.current_state = free_move
	
	elif free_move.is_current_state() and dir == Vector2.ZERO:
		state_machine.current_state = self
