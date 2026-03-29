extends Node
class_name AnimStateMachineManager


@export var anim_manager_path: NodePath= ".."

@export var anim_sm_names: Array[AnimStateMachineGlobalParameters]:
	set = _set_anim_sm_names

@onready var anim_manager: AnimationManagerComponent= get_node_or_null(anim_manager_path)


#### SETTERS ####
func _set_anim_sm_names(value: Array[AnimStateMachineGlobalParameters]) -> void:
	anim_sm_names = value
	
	if not is_node_ready(): return
	
	for sm_parameters in anim_sm_names:
		var sm_name: StringName= sm_parameters.sm_name
		var sm_playback :=anim_manager.get_state_machine_playback(sm_name)
		var anim_sm: AnimationNodeStateMachine= anim_manager.get_animation_node(sm_name)
		
		sm_playback.state_started.connect(_on_state_machine_playback_state_start.bind(sm_name))
		
		if sm_parameters.active_all_transitions:
			active_all_transitions(anim_sm)
		if sm_parameters.global_xfade_time >= 0.0:
			set_all_transition_x_fade_time(anim_sm, sm_parameters.global_xfade_time)

#### BUILT-IN ####
func _ready() -> void:
	await get_tree().process_frame
	_set_anim_sm_names(anim_sm_names)

#### LOGIC ####
func active_transition(transition: AnimationNodeStateMachineTransition) -> void:
	transition.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_ENABLED


func active_all_transitions(state_machine: AnimationNodeStateMachine) -> void:
	for trans_id in state_machine.get_transition_count():
		var trans := state_machine.get_transition(trans_id)
		active_transition(trans)


func set_transition_x_fade_time(transition: AnimationNodeStateMachineTransition, amount: float) -> void:
	transition.xfade_time = amount


func set_all_transition_x_fade_time(state_machine: AnimationNodeStateMachine, amount: float) -> void:
	for trans_id in state_machine.get_transition_count():
		var trans := state_machine.get_transition(trans_id)
		if trans.switch_mode == AnimationNodeStateMachineTransition.SWITCH_MODE_AT_END:
			set_transition_x_fade_time(trans, amount)

#### SIGNALS RESPONSES ####
func _on_state_machine_playback_state_start(_state_name: StringName, anim_sm_name: StringName) -> void:
	var anim_name: StringName= anim_manager.get_animation_name_of(anim_sm_name)
	if anim_name == "": return
	var anim: Animation= anim_manager.get_animation(anim_name)
	
	var blend_node_name: StringName= anim_manager.get_anim_node_connect_to(anim_sm_name)
	var blend_node: AnimationNode= anim_manager.get_animation_node(blend_node_name)
	
	if (blend_node is AnimationNodeBlend2 or blend_node is AnimationNodeOneShot) and anim.get_track_count() != 0:
		anim_manager.change_filter(blend_node_name, anim)
	else :
		anim_manager.reset_filter(blend_node_name)
		if blend_node is AnimationNodeBlend2: anim_manager.set_blend_amount(blend_node_name, 0.0)


#func _on_state_machine_playback_state_exit(_state_name: StringName, anim_sm_name: StringName) -> void:
	#pass
