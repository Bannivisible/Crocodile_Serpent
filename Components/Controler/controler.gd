@abstract
extends Component
class_name Controler


@export var active: bool= true:
	set(value):
		active = value
		set_process_input(active)


@abstract
func _input(event: InputEvent) -> void
