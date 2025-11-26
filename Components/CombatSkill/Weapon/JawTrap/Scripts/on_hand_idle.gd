extends State

@onready var jaw_trap: JawTrap = owner

func enter() -> void:
	jaw_trap.animation_manager_component
