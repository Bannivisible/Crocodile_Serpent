extends Component
class_name AnimationManagerComponent

@export var anim_player_path: NodePath= "AnimationPlayer"
@export var anim_tree_path: NodePath= "AnimationTree"

@onready var animation_player: AnimationPlayer= get_object_node(anim_player_path)
@onready var animation_tree: AnimationTree= get_object_node(anim_tree_path)
@onready var tree_root: AnimationNodeBlendTree= animation_tree.tree_root

@export var lib: AnimationLibrary

func add_library(library: AnimationLibrary) -> void:
	if not animation_tree: return
	animation_player.add_animation_library(library.resource_name, library)

func add_in_tree_animation_with_name(anim_name: StringName) -> void:
	if not animation_tree: return
	var animation := AnimationNodeAnimation.new()
	animation.animation = anim_name
	
	tree_root.add_node(anim_name, animation)

func add_one_shot() -> void:
	AnimationNodeTransition
