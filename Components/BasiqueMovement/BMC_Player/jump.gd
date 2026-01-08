extends BMC_JumpState

@onready var idle_grounded: State = $"../../Grounded/Idle"
@onready var base_state: StateMachine = $"../../../StateMachineX/BaseState"


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Jump") and idle_grounded.is_current_state() and base_state.is_current_state():
		state_machine.current_state = self
