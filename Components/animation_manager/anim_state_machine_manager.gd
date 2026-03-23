extends Node
class_name AnimStateMachineManager


@export var anim_manager_path: NodePath= ".."

@onready var anim_manager: Node= get_node_or_null(anim_manager_path)


func duplicate_state_machine(state_machine: AnimationNodeStateMachine, new_name: StringName) -> AnimationNodeStateMachine:
	var new_state_machine := state_machine.duplicate()
	
	var anim_tree: AnimationTree
	if anim_manager is AnimationTree: anim_tree = anim_manager
	if anim_manager is AnimationManagerComponent: anim_tree = anim_manager.animation_tree
	
	var tree_root: AnimationNodeBlendTree= anim_tree.tree_root
	tree_root.add_node(new_name, new_state_machine)
	
	return state_machine.duplicate()


func active_transition(transition: AnimationNodeStateMachineTransition) -> void:
	transition.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_ENABLED


func active_all_transitions(state_machine: AnimationNodeStateMachine) -> void:
	for trans_id in state_machine.get_transition_count():
		var trans := state_machine.get_transition(trans_id)
		active_transition(trans)
