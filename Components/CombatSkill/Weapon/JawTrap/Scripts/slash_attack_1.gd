extends State

@onready var jaw_trap: JawTrap= owner

var os_name: String= "AttackOneShot"
var attack_name: String= "SlashAttack1"

func enter() -> void:
	var anim_manager: AnimationManagerComponent= jaw_trap.animation_manager_component
	
	if not anim_manager.is_filtred_by(os_name, attack_name):
		
		anim_manager.set_filter_with_all_track(os_name, attack_name)
	
	anim_manager.request_one_shot(os_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
