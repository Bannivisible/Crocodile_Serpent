extends Weapon
class_name JawTrap

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_manager_component: Node = $AnimationManagerComponent


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.set_state_with_string("SlashAttack1")


func _on_animation_manager_component_animation_finished(anim_name: StringName) -> void:
	state_machine.set_state_with_string("Idle")
