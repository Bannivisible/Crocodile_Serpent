extends Component
class_name AnimationManagerComponent

@export var anim_player_path: NodePath= "AnimationPlayer"
@export var anim_tree_path: NodePath= "AnimationTree"

@onready var animation_player: AnimationPlayer= get_object_node(anim_player_path)
@onready var animation_tree: AnimationTree= get_object_node(anim_tree_path)
@onready var tree_root: AnimationNodeBlendTree= animation_tree.tree_root if animation_tree else null

var libraries: Dictionary[AnimationLibrary, StringName]

func add_library(library: AnimationLibrary, lib_name :=StringName(Utiles.get_resource_name(library))) -> void:
	if not animation_tree: return
	libraries[library] = lib_name
	animation_player.add_animation_library(lib_name, library)

func add_in_tree_animation_with_name(anim_path: StringName, anim_name: StringName= Utiles.get_last_string_of_path(anim_path)) -> void:
	if not animation_tree: return
	var animation := AnimationNodeAnimation.new()
	
	animation.animation = anim_path
	
	tree_root.add_node(anim_name, animation)

func add_animation_node(anim_node: AnimationNode, anim_node_name: StringName) -> void:
	if not animation_tree: return
	tree_root.add_node(anim_node_name, anim_node)

func connect_animation_node(output_node_name: StringName, input_id: int, input_node_name: StringName) -> void:
	if not animation_tree: return
	#disconnect_in_connection(input_node_name, input_id)
	tree_root.disconnect_node(input_node_name, input_id)
	tree_root.connect_node(input_node_name, input_id, output_node_name)

func connect_multiply_animation_node(output_nodes_names: Array[StringName], input_node_name: StringName) -> void:
	for i in range(output_nodes_names.size()):
		connect_animation_node(output_nodes_names[i], i, input_node_name)

func disconnect_in_connection(anim_node_name: StringName, id: int) -> void:
	if not tree_root: return
	tree_root.disconnect_node(anim_node_name, id)

func disconnect_out_connection(anim_node_name: StringName, id: int) -> void:
	if not tree_root: return
	tree_root.disconnect_node(anim_node_name, id)

func set_filter_with_all_track(blend_node_name: StringName, node_anime_name: StringName) -> void:
	var blend_node: AnimationNode= tree_root.get_node(blend_node_name)
	var anim_name: StringName= tree_root.get_node(node_anime_name).animation
	var anime: Animation= animation_player.get_animation(anim_name)
	
	for prop_path in get_animation_traks(anime):
		blend_node.set_filter_path(prop_path, true)

func get_animation_traks(anime: Animation) -> Array[NodePath]:
	var properties: Array[NodePath]
	
	for i in anime.get_track_count():
		var prop_path: NodePath= anime.track_get_path(i)
		properties.append(prop_path)
	
	return properties

func get_animation_name(anime: AnimationNode) -> StringName:
	for anim_name in tree_root.get_node_list():
		if tree_root.get_node(anim_name) == anime:
			return anim_name
	return ""

func get_animation_node(anim_name: StringName) -> AnimationNode:
	return tree_root.get_node(anim_name)
