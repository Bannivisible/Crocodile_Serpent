extends Weapon
class_name JawTrap

@onready var state_machine: StateMachine = $StateMachine
@onready var on_hand_machine: Node = $StateMachine/OnHand

@onready var animation_manager_component: AnimationManagerComponent = $AnimationManagerComponent

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("BentDown"):
		
