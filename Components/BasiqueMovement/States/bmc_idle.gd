extends State
class_name BMC_IdleState

func _ready() -> void:
	var bmc: BMC= owner
	bmc.dir_changed.connect(_on_bmc_dir_changed)

func _on_bmc_dir_changed(dir: Vector2) -> void:
	if is_current_state() and dir != Vector2.ZERO:
		state_machine.set_state_with_string("Move")
