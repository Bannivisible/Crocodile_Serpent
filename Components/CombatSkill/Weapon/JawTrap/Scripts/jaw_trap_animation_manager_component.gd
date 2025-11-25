extends AnimationManagerComponent

@export var library: AnimationLibrary

func _ready() -> void:
	add_library(library)
	
	add_in_tree_animation_with_name(libraries[library] + "/SlashAttack1")
	
	add_animation_node(AnimationNodeOneShot.new(), "AttackOneShot")
	set_filter_with_all_track("AttackOneShot", "SlashAttack1")
	disconnect_in_connection("output", 0)
	connect_multiply_animation_node(["StateMachine", "SlashAttack1"], "AttackOneShot")
	connect_animation_node("AttackOneShot", 0, "output")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
