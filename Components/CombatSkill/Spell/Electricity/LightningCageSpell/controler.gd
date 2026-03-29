extends Controler

@onready var state_machine: StateMachine = $"../StateMachine"


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.set_state_with_string("Cast2")
	
	elif Input.is_action_just_released("attack"):
		#state_machine.set_state_with_string("Idle")
		state_machine.current_state = null
