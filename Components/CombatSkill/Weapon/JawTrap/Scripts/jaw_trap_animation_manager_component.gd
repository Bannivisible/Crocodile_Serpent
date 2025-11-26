extends AnimationManagerComponent

@export var library: AnimationLibrary

func _ready() -> void:
	super._ready()
	
	add_library(library)
	_set_attack_one_shot()
	
	add_animation_node(AnimationNodeAdd2.new(), "Add")

func _set_attack_one_shot() -> void:
	add_in_tree_animation_with_name(libraries[library] + "/SlashAttack1")
	add_animation_node(AnimationNodeOneShot.new(), "AttackOneShot")
	set_filter_with_all_track("AttackOneShot", "SlashAttack1")
	disconnect_in_connection("output", 0)
	connect_multiply_animation_node(["StateMachine", "SlashAttack1"], "AttackOneShot")
	connect_animation_node("AttackOneShot", 0, "output")
