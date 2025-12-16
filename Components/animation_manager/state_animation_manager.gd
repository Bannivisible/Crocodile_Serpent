extends Component
class_name StateAnimationManager

@export_enum("Play", "Blend") var play_mode: String= "Blend"

@export var state_machines: Array[StateMachine]

@export var state_add_anim_name: StringName= "StateAddAnimation"
@export var state_os_anim_name: StringName= "StateOneShotAnimation"

@onready var anim_manager: AnimationManagerComponent= get_parent()

#### BUILT IN ####

func _ready() -> void:
	for state_machine in state_machines:
		state_machine.state_changed.connect(_on_state_machine_state_changed)
		state_machine.state_changed_recur.connect(_on_state_machine_state_changed_recur)

#### LOGIC ####
func _get_anim_name(state: State) -> StringName:
	var anim_name: StringName= &""
	
	for i in range(state_machines.size()):
		anim_name += state_machines[i].get_chained_state_string()
		if i < state_machines.size() - 1: anim_name += "|"
	
	return anim_manager.get_anime_complete_name(anim_name)

func _add_logic(anim_name: StringName) -> void:
	var connection: AnimationConnection= anim_manager.get_connection_with_from(state_add_anim_name)
	var add_node_name: StringName= connection.to
	
	anim_manager.tween_add_amount(add_node_name, 0.2, 0.0)
	
	anim_manager.reset_filter(state_add_anim_name)
	anim_manager.change_animation(state_add_anim_name, anim_name)
	anim_manager.set_filter_with_all_track(add_node_name, state_add_anim_name)
	
	anim_manager.tween_add_amount(add_node_name, 0.2, 1.0)

func _one_shot_logic(anim_name:StringName) -> void:
	var connection: AnimationConnection= anim_manager.get_connection_with_from(state_add_anim_name)
	var os_node_name: StringName= connection.to
	
	anim_manager.reset_filter(state_add_anim_name)
	anim_manager.change_animation(state_add_anim_name, anim_name)
	anim_manager.set_filter_with_all_track(os_node_name, state_add_anim_name)
	
	anim_manager.request_one_shot(os_node_name)

func _play_state_anime(state: State) -> void:
	if state is AttackState: return
	var anim_name: StringName= state.get_chained_string()
	
	match play_mode:
		"Play": 
			if anim_manager.has_animation(anim_name):
				anim_manager.play_animation(anim_name)
		"Blend":
			if anim_manager.get_animation(anim_name).loop_mode == Animation.LOOP_NONE:
				_one_shot_logic(anim_name)
			else :
				_add_logic(anim_name)

#### SIGNAL RESPONSES ####

func _on_state_machine_state_changed(state: State) -> void:
	_play_state_anime(state)

func _on_state_machine_state_changed_recur(_state: State, deep_state: State) -> void:
	_play_state_anime(deep_state)
