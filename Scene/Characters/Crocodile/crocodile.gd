extends Character

@onready var free: BMC_FreeState = $BMC/StateMachineY/Air/Free

@onready var bmc: BMC = $BMC



#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("special"):
		#free.set_state_with_string("FreeIdle")

func set_free_idle() -> void:
	free.set_state_with_string("FreeIdle")
