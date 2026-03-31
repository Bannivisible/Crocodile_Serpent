extends State

@export var next_state: State

func _input(_event: InputEvent) -> void:
	if is_current_state() and Input.is_action_just_pressed("special"):
		get_top_state_machine().set_state(next_state)
