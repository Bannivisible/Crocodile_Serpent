extends State

@onready var jaw_trap: JawTrap = owner

#func enter() -> void:
	#jaw_trap.animation_manager_component


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed("attack") and is_current_state():
		#state_machine.set_state_with_string("ConstantRotatingAttack")
	#
	#if Input.is_action_just_pressed("attack"):
		#state_machine.set_state_with_string("SlashAttack1")
