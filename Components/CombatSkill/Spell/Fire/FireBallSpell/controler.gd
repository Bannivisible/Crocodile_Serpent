extends Controler


@onready var state_machine: StateMachine = $"../StateMachine"

var id_cast: int= 2

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		var state_name: StringName= _get_cast_state_name()
		state_machine.set_state_with_string(state_name)


func _get_cast_state_name() -> StringName:
	var state_name: StringName= "Cast"
	
	id_cast = 1 if id_cast != 1 else 2
	if id_cast > 1:  state_name += str(id_cast)
	
	return state_name
