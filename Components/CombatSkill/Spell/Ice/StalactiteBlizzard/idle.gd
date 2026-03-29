extends State

@onready var state_machine_animation: StateMachine = $"../../StateMachineAnimation"

func enter() -> void:
	if not is_node_ready(): await ready
	state_machine_animation.set_state_with_string("Void")
	owner.free_player()


func exit() -> void:
	state_machine_animation.set_state_with_string("Control")
