extends StateMachine

@onready var velocity_component: VelocityComponent = $"../VelocityComponent"


#### BUILT-IN ####


#### LOGIC ####
func _set_state_based_on_dir(dir: Vector2) -> void:
	if not velocity_component.character.is_on_floor(): return
	
	var state_name: String= get_deepest_state().name
	var idle_suffixe: String= "Idle"
	var move_suffixe: String= "Move"
	
	
	if dir.x == 0.0 and state_name.ends_with(move_suffixe):
		var lenght: int= len(state_name) - len(move_suffixe)
		var idle_state_name: String= state_name.substr(0, lenght)
		idle_state_name += idle_suffixe
		
		set_state_with_string(idle_state_name)
	
	elif state_name.ends_with(idle_suffixe):
		var lenght: int= len(state_name) - len(idle_suffixe)
		var move_state_name: String= state_name.substr(0, lenght)
		move_state_name += move_suffixe
		
		set_state_with_string(move_state_name)


#### SIGNALS RESPONSES ####
func _on_velocity_component_dir_changed(dir: Vector2) -> void:
	velocity_component.update_velocity_x()
	
	_set_state_based_on_dir(dir)
