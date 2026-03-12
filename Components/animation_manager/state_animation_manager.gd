extends Component
class_name StateAnimationManager

enum PLAY_MODE {
	PLAY,
	Blend,
	TRAVEL
}


@export var active: bool= true

@export var anim_manager_path: NodePath= ".."

@export var play_reset: bool= true

@export var play_mode := PLAY_MODE.PLAY

@export var state_machine: StateMachine:
	set = _set_state_machine

@export_group("Blend")
@export var state_blend_anim_name: StringName= "StateBlendAnimation"
@export var state_os_anim_name: StringName= "StateOneShotAnimation"

@export_group("Travel")
@export var anim_state_machine_path: String= "StateMachine":
	set = _set_anim_state_machine_path

@onready var anim_manager: Node= get_node_or_null(anim_manager_path)


@onready var state_machine_playback: AnimationNodeStateMachinePlayback= _get_state_machine_playback()


#### SETTERS ####
func _set_state_machine(value: StateMachine) -> void:
	if state_machine: state_machine.state_changed_recur.disconnect(_on_state_machine_state_changed_recur)
	
	state_machine = value
	
	if state_machine: state_machine.state_changed_recur.connect(_on_state_machine_state_changed_recur)


func _set_anim_state_machine_path(value: String) -> void:
	anim_state_machine_path = value
	state_machine_playback = _get_state_machine_playback()

#### BUILT IN ####

func _ready() -> void:
	if not object.is_node_ready(): await object.ready
	if not owner.is_node_ready(): await  owner.ready
	
	var state: State= state_machine.current_state
	_play_state_anime(state)
	while state is StateMachine:
		state = state.current_state
		_play_state_anime(state)

#### LOGIC ####
func _get_anim_name(state: State) -> String:
	var anim_name: String= state.get_chained_string()
	anim_name = anim_name.substr(len(state_machine.name) + 1)
	
	if anim_manager is AnimationManagerComponent:
		anim_name = anim_manager.get_anime_complete_name(anim_name)
	
	return anim_name


func _get_state_machine_playback() -> AnimationNodeStateMachinePlayback:
	if play_mode != PLAY_MODE.TRAVEL: return
	
	var path: String= "parameters/"
	path += anim_state_machine_path + "/playback"
	
	if anim_manager is AnimationTree:
		return anim_manager.get(path)
	if anim_manager is AnimationManagerComponent:
		return anim_manager.animation_tree.get(path)
	
	return null


func _blend_logic(anim_name: StringName) -> void:
	var connection: AnimationConnection= anim_manager.get_connection_with_from(state_blend_anim_name)
	var blend_node_name: StringName= connection.to
	
	anim_manager.tween_blend_amount(blend_node_name, 0.2, 0.0)
	
	anim_manager.reset_filter(state_blend_anim_name)
	anim_manager.change_animation(state_blend_anim_name, anim_name)
	anim_manager.set_filter_with_all_track(blend_node_name, state_blend_anim_name)
	
	anim_manager.tween_blend_amount(blend_node_name, 0.2, 1.0)


func _one_shot_logic(anim_name: StringName) -> void:
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
		PLAY_MODE.PLAY: _match_play(anim_name)
		PLAY_MODE.Blend: _match_blend(anim_name)
		PLAY_MODE.TRAVEL: _match_travel(anim_name)


func _match_play(anim_name: StringName) -> void:
	if not anim_manager.current_animation != anim_name: return
	
	if anim_manager is AnimationPlayer:
		anim_manager.stop()
		
		if play_reset: 
			anim_manager.play("RESET")
			anim_manager.stop()
		
		anim_manager.play(anim_name)


func _match_blend(anim_name: StringName) -> void:
	if anim_manager.get_animation(anim_name).loop_mode == Animation.LOOP_NONE:
		_one_shot_logic(anim_name)
	else :
		_blend_logic(anim_name)


func _match_travel(anim_name: StringName) -> void:
	if anim_manager is AnimationTree and state_machine_playback:
		
		state_machine_playback.travel(anim_name)

#### SIGNAL RESPONSES ####
func _on_state_machine_state_changed_recur(_state: State, deep_state: State) -> void:
	if active: _play_state_anime(deep_state)
