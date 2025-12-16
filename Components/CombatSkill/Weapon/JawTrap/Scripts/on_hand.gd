extends StateMachine

@onready var jaw_trap: JawTrap = $"../.."


func enter() -> void:
	var an = jaw_trap.animation_manager_component
	an.play_animation("JawTrapAnimationLibrary/OnHand")
