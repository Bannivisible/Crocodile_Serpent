extends Character

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

func _input(_event: InputEvent) -> void:
	var playback: AnimationNodeStateMachinePlayback= animation_tree.get("parameters/StateMachine/playback")
	if Input.is_action_just_pressed("up"):
		playback.travel("ToCharge")
	if Input.is_action_just_pressed("down"):
		playback.travel("ToChargeBackward")
