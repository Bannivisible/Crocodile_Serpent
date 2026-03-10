extends StateMachine
class_name CharacStateMachine

@export var velocity_component: VelocityComponent

#### BUILT-IN ####
func _ready() -> void:
	super._ready()
	
	velocity_component.dir_changed.connect(_on_velocity_component_dir_changed)

#### LOGIC ####
func _set_state_based_on_dir(dir: Vector2) -> void:
	if not velocity_component.character.is_on_floor(): return
	
	var state: State= get_deepest_state()
	var state_name: String= state.name
	var idle_preffixe: String= "Idle"
	var move_preffixe: String= "Move"
	
	if dir.x == 0.0 and state_name.begins_with(move_preffixe):
		var idle_state_name: String= state_name.substr(len(move_preffixe))
		idle_state_name = idle_preffixe + idle_state_name
		
		state.state_machine.set_state_with_string(idle_state_name)
	
	elif state_name.begins_with(idle_preffixe):
		var move_state_name: String= state_name.substr(len(idle_preffixe))
		move_state_name = move_preffixe + move_state_name
		
		state.state_machine.set_state_with_string(move_state_name)

#### SIGNALS RESPONSES ####
func _on_velocity_component_dir_changed(dir: Vector2) -> void:
	velocity_component.update_velocity_x()
	
	_set_state_based_on_dir(dir)
