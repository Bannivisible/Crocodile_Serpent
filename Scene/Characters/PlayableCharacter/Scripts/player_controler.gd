extends Controler
class_name PlayerControler

@export var jump_mitigation: float= 4.0

@export var velocity_component: VelocityComponent

@export var state_machine: StateMachine
@export var jump_state: State
@export var fall_state: State


func _input(_event: InputEvent) -> void:
	if not active: return
	
	velocity_component.dir.x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		state_machine.set_state(jump_state)
	
	elif Input.is_action_just_released("jump") and jump_state.is_current_state():
		owner.velocity.y = - jump_state.force / jump_mitigation
		state_machine.set_state(fall_state)

