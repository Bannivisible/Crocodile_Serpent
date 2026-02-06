extends State
class_name VelocityComponent_IdleState

func _ready() -> void:
	var velocity_component: VelocityComponent= owner
	velocity_component.dir_changed.connect(_on_VelocityComponent_dir_changed)

func _on_VelocityComponent_dir_changed(dir: Vector2) -> void:
	if is_current_state() and dir != Vector2.ZERO:
		state_machine.set_state_with_string("Move")
