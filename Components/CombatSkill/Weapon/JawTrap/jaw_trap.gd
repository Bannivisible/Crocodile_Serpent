extends Weapon
class_name JawTrap

@onready var state_machine: StateMachine = $StateMachine
@onready var on_hand_machine: Node = $StateMachine/OnHand

@onready var anim_manager: AnimationManagerComponent = $AnimationManagerComponent

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("bent_down"):
		#anim_manager.print_blendtree()
		#anim_manager.print_all_connections()
