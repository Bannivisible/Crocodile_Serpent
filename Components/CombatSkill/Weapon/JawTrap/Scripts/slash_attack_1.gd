extends State

@onready var jaw_trap: JawTrap= owner

func enter() -> void:
	var anim_manager: AnimationManagerComponent= jaw_trap.animation_manager_component
	anim_manager.animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
