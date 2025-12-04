extends AnimationManagerComponent

@export var library: AnimationLibrary

func _ready() -> void:
	super._ready()
	
	add_library(library)
	reset_animation = add_library_to_name(reset_animation, library)
	play_reset_animation()
	
	_set_attack_one_shot()
	
	add_animation_node(AnimationNodeAdd2.new(), "Add2")

func _set_attack_one_shot() -> void:
	add_in_tree_animation_with_name(libraries[library] + "/SlashAttack1", "Attack")
	add_animation_node(AnimationNodeOneShot.new(), "OneShot")
	set_filter_with_all_track("OneShot", "Attack")
	disconnect_in_connection("output", 0)
	connect_multiply_animation_node(["StateMachine", "Attack"], "OneShot")
	connect_animation_node("OneShot", 0, "output")
