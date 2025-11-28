extends State

@onready var jaw_trap: JawTrap= owner

func enter() -> void:
	var anim_manager : AnimationManagerComponent= jaw_trap.animation_manager_component
	anim_manager.change_animation("Attack", "JawTrap/SlashAttack2")
