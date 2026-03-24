extends Character

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_manager_component: AnimationManagerComponent = $AnimationManagerComponent

func _input(_event: InputEvent) -> void:
	var playback: AnimationNodeStateMachinePlayback= animation_tree.get("parameters/AnimationNodeStateMachine 2/playback")
	if Input.is_action_just_pressed("up"):
		#playback.travel("Charge")
		animation_manager_component.setup_blend_node("Blend2", "Charge")
		#print(animation_tree.get("parameters/Blend2/blend_amount"))
		#print(playback.get_current_node())
		#
	if Input.is_action_just_pressed("down"):
		playback.travel("ToChargeBackward")
