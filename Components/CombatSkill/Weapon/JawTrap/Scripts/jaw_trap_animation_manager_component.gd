extends AnimationManagerComponent

@export var library: AnimationLibrary

func _ready() -> void:
	super._ready()
	
	add_library(library)
	reset_animation = add_library_to_name(reset_animation, library)
	play_reset_animation()
	
	_set_attack_one_shot()


func _set_attack_one_shot() -> void:
	add_in_tree_animation_with_name(libraries[library] + "/SlashAttack1", "Attack")
	connect_multiply_animation_node(["StateMachine", "Attack"], "OneShot")
	#connect_animation_node("StateMachine", 0, "OneShot")
	connect_animation_node("OneShot", 0, "output")

#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("BentDown"):
		#print_all_connections()
