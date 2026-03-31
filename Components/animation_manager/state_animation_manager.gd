extends Component
class_name StateAnimationManager

enum PLAY_MODE {
	PLAY,
	BLEND,
	SHOT,
	TRAVEL,
	MIX
}


@export var active: bool= true

@export var anim_manager_path: NodePath= ".."

@export var play_mode := PLAY_MODE.PLAY

@export var state_machine: StateMachine:
	set = _set_state_machine

@export var exceptions: Dictionary[String, StringName]

@export_group("Play")
@export var play_reset: bool

@export_group("Blend")
@export var blend_node_name: StringName= "Blend2"

@export_group("Shot")
@export var os_node_name: StringName= "OneShot"

@export_group("Travel")
@export var anim_sm_name: String= "AnimationNodeStateMachine":
	set = _set_anim_sm_name

@onready var anim_manager: AnimationManagerComponent= get_node_or_null(anim_manager_path)


#### SETTERS ####
func _set_state_machine(value: StateMachine) -> void:
	if state_machine: state_machine.state_changed_recur.disconnect(_on_state_machine_state_changed_recur)
	
	state_machine = value
	
	if state_machine: state_machine.state_changed_recur.connect(_on_state_machine_state_changed_recur)


func _set_anim_sm_name(value: String) -> void:
	anim_sm_name = value

#### BUILT IN ####
func _enter_tree() -> void:
	if not is_node_ready(): await get_tree().process_frame
	
	for state in state_machine.get_chained_state_list():
		_play_state_anime(state)


func _exit_tree() -> void:
	_play_anim(AnimationManagerComponent.EXIT_ANIM_NAME)
	
	if play_mode == PLAY_MODE.SHOT:
		anim_manager.reset_filter(os_node_name)
		var os : AnimationNodeOneShot= anim_manager.get_animation_node(os_node_name)
		os.filter_enabled = true

#### LOGIC ####
func _get_anim_name(state: State) -> String:
	var anim_name: String= state.get_chained_string()
	anim_name = anim_name.substr(len(state_machine.name) + 1)
	
	if exceptions.has(anim_name):
		anim_name = exceptions[anim_name]
	
	return anim_name


func _get_state_machine_playback() -> AnimationNodeStateMachinePlayback:
	return anim_manager.get_state_machine_playback(anim_sm_name)


func _get_anim_state_machine() -> AnimationNodeStateMachine:
	return anim_manager.get_animation_node(anim_sm_name)


func _play_state_anime(state: State) -> void:
	if state == null: return
	
	var anim_name: StringName= _get_anim_name(state)
	
	_play_anim(anim_name)


func _play_anim(anim_name: StringName) -> void:
	match play_mode:
		PLAY_MODE.PLAY: _match_play(anim_name)
		PLAY_MODE.BLEND: _match_blend(anim_name)
		PLAY_MODE.SHOT: _match_one_shot(anim_name)
		PLAY_MODE.TRAVEL: _match_travel(anim_name)
		PLAY_MODE.MIX: _match_mix(anim_name)


func _match_play(anim_name: StringName) -> void:
	if not anim_manager.has_animation(anim_name): return
	var anim_player: AnimationPlayer = anim_manager.animation_player
	
	if anim_player.current_animation == anim_name: return
	anim_player.stop()
	
	if play_reset: 
		anim_player.play("RESET")
		anim_player.stop()
	
	anim_player.play(anim_name)


func _match_blend(anim_name: StringName) -> void:
	var anim: Animation= anim_manager.get_animation(anim_name)
	if anim != null:
		anim_manager.setup_blend_node(blend_node_name, anim_name)
	
	elif anim_manager is AnimationManagerComponent:
		var sm_name: StringName=anim_manager.get_connection_with_to_and_port(blend_node_name, 1).from
		var anim_sm = anim_manager.get_animation_node(sm_name)
		
		if anim_sm is AnimationNodeStateMachine and anim_name in anim_sm.get_node_list():
			var true_anim_name: StringName= anim_manager.get_animation_name_of_node(anim_sm.get_node(anim_name))
		
			anim_manager.setup_blend_node(blend_node_name, anim_name, true_anim_name)


func _match_one_shot(anim_name: StringName) -> void:
	var anim: Animation= anim_manager.get_animation(anim_name)
	if anim != null and anim.loop_mode == Animation.LOOP_NONE:
		anim_manager.setup_one_shot(os_node_name, anim_name)
	
	elif anim_manager is AnimationManagerComponent:
		var sm_name: StringName=anim_manager.get_connection_with_to_and_port(os_node_name, 1).from
		var anim_sm = anim_manager.get_animation_node(sm_name)
		
		if anim_sm is AnimationNodeStateMachine and anim_name in anim_sm.get_node_list():
			var true_anim_name: StringName= anim_manager.get_animation_name_of_node(anim_sm.get_node(anim_name))
			if not anim_manager.get_animation(true_anim_name).loop_mode == Animation.LOOP_NONE: return
			
			anim_manager.setup_one_shot(os_node_name, anim_name, true_anim_name)


func _match_travel(anim_name: StringName) -> void:
	var state_machine_playback := _get_state_machine_playback()
	var anim_sm := _get_anim_state_machine()
	
	if state_machine_playback and anim_sm.has_node(anim_name):
		state_machine_playback.travel(anim_name)


func _match_mix(anim_name: StringName) -> void:
	var anim: Animation= anim_manager.get_animation(anim_name)
	if not anim: return
	
	if anim.loop_mode == Animation.LOOP_NONE:
		anim_manager.setup_one_shot(os_node_name, anim_name)
	else :
		anim_manager.setup_blend_node(blend_node_name, anim_name)

#### SIGNAL RESPONSES ####
func _on_state_machine_state_changed_recur(_state: State, deep_state: State) -> void:
	if active: _play_state_anime(deep_state)
