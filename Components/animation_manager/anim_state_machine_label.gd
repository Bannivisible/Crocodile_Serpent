extends Label
class_name AnimStateMachineLabel

@export var anim_tree: AnimationTree
@export var state_machine_name: StringName


func _ready() -> void:
	var playback: AnimationNodeStateMachinePlayback=anim_tree.get("parameters/%s/playback" % state_machine_name)
	playback.state_started.connect(_on_state_machine_playback_state_started)


func _on_state_machine_playback_state_started(state_name: StringName) -> void:
		text = state_name
