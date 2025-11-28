extends Weapon
class_name JawTrap

@onready var state_machine: StateMachine = $StateMachine
@onready var on_hand_machine: Node = $StateMachine/OnHand

@onready var animation_manager_component: Node = $AnimationManagerComponent


func _on_animation_manager_component_animation_finished(_anim_name: StringName) -> void:
	on_hand_machine.set_state_with_string("Idle")
