extends PlayerControler


@onready var bent_down_state: State = $"../StateMachine/BentDown/IdleB"


func _input(_event: InputEvent) -> void:
	super._input(_event)
	
	if Input.is_action_just_released("bent_down") and bent_down_state.is_current_state():
		state_machine.set_state_with_string("Idle")
	
	elif Input.is_action_just_pressed("bent_down") and owner.is_on_floor():
		state_machine.set_state(bent_down_state)
