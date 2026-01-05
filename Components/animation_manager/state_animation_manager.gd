extends Component
class_name StateAnimationManager

@export_enum("Play", "Blend") var play_mode: String= "Blend"

@export var state_machines: Array[StateMachine]

@export var state_blend_anim_name: StringName= "StateBlendAnimation"
@export var state_os_anim_name: StringName= "StateOneShotAnimation"

@onready var anim_manager: Node= _obtain_anim_manager()

#### BUILT IN ####

func _ready() -> void:
	for state_machine in state_machines:
		state_machine.state_changed.connect(_on_state_machine_state_changed)
		state_machine.state_changed_recur.connect(_on_state_machine_state_changed_recur)
	
	if not object.is_node_ready(): await object.ready
	
	if state_machines[0]:
		_play_state_anime(state_machines[0].get_deepest_state())

#### LOGIC ####
func _obtain_anim_manager() -> Node:
	var parent: Node= get_parent()
	if parent is AnimationManagerComponent or parent is AnimationPlayer:
		return parent
	else : return null

func _get_anim_name(state: State) -> String:
	var anim_name: String= ""
	var top_state_machine := state.get_top_state_machine()
	
	for i in range(state_machines.size()):
		if state_machines[i] == top_state_machine:
			anim_name = state.get_chained_string()
			anim_name = anim_name.substr(len(top_state_machine.name) + 1)
			
		else :
			anim_name = state_machines[i].get_chained_state_string()
		
		if i < state_machines.size() - 1: anim_name += "|"
	
	anim_name = _get_existing_anim_name(anim_name)
	
	return anim_name

func _get_existing_anim_name(anim_name: String) -> String:
	if anim_manager is AnimationManagerComponent:
		anim_name = anim_manager.get_anime_complete_name(anim_name)
	
	if anim_manager.has_animation(anim_name):
		return anim_name
	
	for i in range(state_machines.size() - 1):
		anim_name = Utiles.end_substr_until_meet(anim_name, "|")
		
		if anim_manager is AnimationManagerComponent:
			anim_name = anim_manager.get_anime_complete_name(anim_name)
		
		if anim_manager.has_animation(anim_name):
			return anim_name
	
	return ""

func _blend_logic(anim_name: StringName) -> void:
	var connection: AnimationConnection= anim_manager.get_connection_with_from(state_blend_anim_name)
	var blend_node_name: StringName= connection.to
	
	anim_manager.tween_blend_amount(blend_node_name, 0.2, 0.0)
	
	anim_manager.reset_filter(state_blend_anim_name)
	anim_manager.change_animation(state_blend_anim_name, anim_name)
	anim_manager.set_filter_with_all_track(blend_node_name, state_blend_anim_name)
	
	anim_manager.tween_blend_amount(blend_node_name, 0.2, 1.0)

func _one_shot_logic(anim_name:StringName) -> void:
	var connection: AnimationConnection= anim_manager.get_connection_with_from(state_os_anim_name)
	var os_node_name: StringName= connection.to
	
	anim_manager.reset_filter(state_os_anim_name)
	anim_manager.change_animation(state_os_anim_name, anim_name)
	anim_manager.set_filter_with_all_track(os_node_name, state_os_anim_name)
	
	anim_manager.request_one_shot(os_node_name)

func _play_state_anime(state: State) -> void:
	if state == null: return
	var anim_name: StringName= _get_anim_name(state)
	
	if not anim_manager.has_animation(anim_name): return
	
	match play_mode:
		"Play":
			anim_manager.play(anim_name)
		"Blend":
			if anim_manager.get_animation(anim_name).loop_mode == Animation.LOOP_NONE:
				_one_shot_logic(anim_name)
			else :
				_blend_logic(anim_name)

#### SIGNAL RESPONSES ####

func _on_state_machine_state_changed(state: State) -> void:
	_play_state_anime(state)

func _on_state_machine_state_changed_recur(_state: State, deep_state: State) -> void:
	_play_state_anime(deep_state)
	
