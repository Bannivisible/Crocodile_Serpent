extends Node
class_name AnimStateMachineManager


@export var anim_manager_path: NodePath= ".."

@export var anim_sm_names: Array[StringName]:
	set = _set_anim_sm_names

@onready var anim_manager: AnimationManagerComponent= get_node_or_null(anim_manager_path)


#### SETTERS ####
func _set_anim_sm_names(value: Array[StringName]) -> void:
	anim_sm_names = value
	
	if not is_node_ready(): return
	
	for sm_name in anim_sm_names:
		var sm_playback :=anim_manager.get_state_machine_playback(sm_name)
		sm_playback.state_started.connect(_on_state_machine_playback_state_start.bind(sm_name))

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

#### SIGNALS RESPONSES ####
func _on_state_machine_playback_state_start(state_name: StringName, anim_sm_name: StringName, playback: AnimationNodeStateMachinePlayback) -> void:
	#var anim_sm: AnimationNodeStateMachine= anim_manager.get_animation_node(state_name)
	#var anim_name: StringName= anim_manager
	
	var blend_node_name: StringName= anim_manager.get_anim_node_connect_to(anim_sm_name)
	var blend_node: AnimationNode= anim_manager.get_animation_node(blend_node_name)
	
	if blend_node is AnimationNodeBlend2:
		anim_manager.setup_blend_node(blend_node_name, state_name)
	elif blend_node is AnimationNodeOneShot:
		anim_manager.setup_one_shot(blend_node_name, state_name)
