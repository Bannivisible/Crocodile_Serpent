extends PlayableCharacter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_manager_component: AnimationManagerComponent = $AnimationManagerComponent

#func _input(_event: InputEvent) -> void:
	#var playback: AnimationNodeStateMachinePlayback= animation_tree.get("parameters/AnimationNodeStateMachine 2/playback")
	#if Input.is_action_just_pressed("up"):
		#print(animation_manager_component.tracks_filter["OneShot"])
		#print(animation_manager_component.tracks_filter["Blend2"])
		#animation_manager_component.reset_filter("Blend2")
		
		
		
		
	#elif Input.is_action_just_pressed("down"):
		#animation_manager_component.setup_one_shot("OneShot", "Void")
	



#func _process(delta: float) -> void:
	#print(animation_manager_component.get_animation_name("Animation"))
