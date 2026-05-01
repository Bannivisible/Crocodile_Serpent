extends State
class_name JumpTo


@export var target: Vector2
@export var velocity_comp: VelocityComponent
@export var jump_state: State

@onready var path_manager: PathManager= velocity_comp.get_node("PathManager")


#### BUILT IN ####
func enter() -> void:
	path_manager.add_target_at_begining(target)
	path_manager.active = true
	jump_state.state_machine.current_state = jump_state


#### LOGIC ####
#func _get_height():
	#pass
