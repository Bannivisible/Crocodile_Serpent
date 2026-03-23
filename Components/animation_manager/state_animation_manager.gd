extends Component
class_name StateAnimationManager

enum PLAY_MODE {
	PLAY,
	Blend,
	TRAVEL
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
@export var os_node_name: StringName= "OneShot"

@export_group("Travel")
@export var anim_state_machine_path: String= "AnimationNodeStateMachine":
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
func _enter_tree() -> void:
	await get_tree().process_frame
	
	for state in state_machine.get_chained_state_list():
		_play_state_anime(state)


func _exit_tree() -> void:
	_play_anim(AnimationManagerComponent.EXIT_ANIM_NAME)

#### LOGIC ####
func _get_anim_name(state: State) -> String:
	var anim_name: String= state.get_chained_string()
	anim_name = anim_name.substr(len(state_machine.name) + 1)
	
	if exceptions.has(anim_name):
		anim_name = exceptions[anim_name]
	
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
	if anim_manager is AnimationManagerComponent:
		anim_manager.setup_blend_node(blend_node_name, anim_name)


func _one_shot_logic(anim_name: StringName) -> void:
	if anim_manager is AnimationManagerComponent:
		anim_manager.setup_one_shot(os_node_name, anim_name)


func _play_state_anime(state: State) -> void:
	if state == null: return
	
	var anim_name: StringName= _get_anim_name(state)
	
	_play_anim(anim_name)


func _play_anim(anim_name: StringName) -> void:
	if not anim_manager.has_animation(anim_name): return
	
	match play_mode:
		PLAY_MODE.PLAY: _match_play(anim_name)
		PLAY_MODE.Blend: _match_blend(anim_name)
		PLAY_MODE.TRAVEL: _match_travel(anim_name)


func _match_play(anim_name: StringName) -> void:
	var anim_player: AnimationPlayer
	
	if anim_manager is AnimationPlayer: anim_player = anim_manager
	elif anim_manager is AnimationManagerComponent: anim_player = anim_manager.animation_player
	
	if anim_player.current_animation == anim_name: return
	anim_player.stop()
	
	if play_reset: 
		anim_player.play("RESET")
		anim_player.stop()
	
	anim_player.play(anim_name)


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
