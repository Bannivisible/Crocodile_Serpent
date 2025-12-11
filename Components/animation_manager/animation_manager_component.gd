extends Component
class_name AnimationManagerComponent

@export var anim_player_path: NodePath= "AnimationPlayer"
@export var anim_tree_path: NodePath= "AnimationTree"

@onready var animation_player: AnimationPlayer= get_object_node(anim_player_path)
@onready var animation_tree: AnimationTree= get_object_node(anim_tree_path)
@onready var tree_root: AnimationNodeBlendTree= animation_tree.tree_root if animation_tree else null

@export var reset_animation: StringName= "RESET"

@export var anim_connect_list: AnimationConnectionsList

var libraries: Dictionary[AnimationLibrary, StringName]

var tracks_filter: Dictionary[StringName, StringName]= {}

signal animation_finished(anim_name: StringName)

#### BUILT-IN ####

func _ready() -> void:
	var on_animation_finished: Callable= func(anim_name: StringName): animation_finished.emit(anim_name)
	
	animation_player.animation_finished.connect(on_animation_finished)
	animation_tree.animation_finished.connect(on_animation_finished)

#### LOGIC ####

func add_library(library: AnimationLibrary, lib_name :=StringName(Utiles.get_resource_name(library))) -> void:
	if not animation_tree: return
	libraries[library] = lib_name
	
	if not animation_player.has_animation_library(lib_name):
		animation_player.add_animation_library(lib_name, library)

func play_animation(anim_name: StringName) -> void:
	animation_player.play(anim_name)

func get_current_animation_name() -> String:
	return animation_player.current_animation

func play_reset_animation() -> void:
	if animation_player.has_animation(reset_animation):
		animation_player.play(reset_animation)

### TREE ROOT ###

func request_reset_one_shot(anim_node_name: StringName, one_shot_name) -> void:
	change_animation(anim_node_name, reset_animation)
	set_filter_with_all_track(one_shot_name, anim_node_name)
	connect_animation_node(anim_node_name, 1, one_shot_name)
	request_one_shot(one_shot_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func add_in_tree_animation_with_name(anim_name: StringName, anim_node_name: StringName) -> void:
	if not animation_tree: return
	var animation := AnimationNodeAnimation.new()
	
	animation.animation = anim_name
	
	tree_root.add_node(anim_node_name, animation)

func add_animation_node(anim_node: AnimationNode, anim_node_name: StringName) -> void:
	if not animation_tree: return
	tree_root.add_node(anim_node_name, anim_node)

func connect_animation_node(output_node_name: StringName, input_id: int, input_node_name: StringName) -> void:
	if not tree_root: return
	
	disconnect_in_connection(input_node_name, input_id)
	disconnect_out_connection(output_node_name)
	
	tree_root.connect_node(input_node_name, input_id, output_node_name)
	
	anim_connect_list.connections.append(AnimationConnection.new(output_node_name, input_node_name, input_id))

func connect_multiply_animation_node(output_nodes_names: Array[StringName], input_node_name: StringName) -> void:
	for i in range(output_nodes_names.size()):
		connect_animation_node(output_nodes_names[i], i, input_node_name)

func disconnect_in_connection(anim_node_name: StringName, port: int) -> void:
	if not tree_root: return
	tree_root.disconnect_node(anim_node_name, port)
	
	var connection := get_connection_with_to_and_port(anim_node_name, port)
	anim_connect_list.connections.erase(connection)

func disconnect_out_connection(anim_node_name: StringName) -> void:
	var from_connection := get_connection_with_from(anim_node_name)
	if not from_connection: return
	
	disconnect_in_connection(from_connection.to, from_connection.to_port)

func set_filter_with_all_track(blend: StringName, anim_node: StringName, activate: bool= true) -> void:
	var blend_node: AnimationNode= tree_root.get_node(blend)
	
	var anim_name: StringName= tree_root.get_node(anim_node).animation
	var anime: Animation= animation_player.get_animation(anim_name)
	tracks_filter[blend] = anim_name
	
	for prop_path in get_animation_traks(anime):
		blend_node.set_filter_path(prop_path, activate)

func reset_filter(blend: StringName) -> void:
	set_filter_with_all_track(blend, tracks_filter[blend], false)

func is_filtred_by(blend: String, anim_name: String) -> bool:
	return tracks_filter[blend] == anim_name

func change_animation(anim_node: StringName, anim_name: StringName) -> void:
	var anime: AnimationNodeAnimation= tree_root.get_node(anim_node)
	var anime_name= anim_name
	
	anime.animation = anime_name

func convert_all_connections(anim_nd_name1: StringName, anim_nd_name2: StringName) -> void:
	var nd1_from_connection: AnimationConnection= get_connection_with_from(anim_nd_name1)
	convert_from_connection(nd1_from_connection, anim_nd_name2)
	
	var nd1_to_connections: Array[AnimationConnection]= get_connections_with_to(anim_nd_name1)
	for connection in nd1_to_connections:
		convert_to_connection(connection, anim_nd_name2)

func convert_from_connection(connection: AnimationConnection, anim_node_name: StringName) -> void:
	disconnect_out_connection(connection.from)
	disconnect_out_connection(anim_node_name)
	connect_animation_node(anim_node_name, connection.to_port, connection.to)

func convert_to_connection(connection: AnimationConnection, anim_node_name: StringName) -> void:
	disconnect_in_connection(connection.to, connection.to_port)
	disconnect_in_connection(anim_node_name, connection.to_port)
	connect_animation_node(connection.from, connection.to_port, anim_node_name)

func has_out_connection(anim_node_name: StringName) -> bool:
	return get_connection_with_from(anim_node_name) != null

func add_library_to_name(anim_name: StringName, lib: AnimationLibrary) -> StringName:
	var lib_name: StringName
	
	if lib in libraries.keys():
		lib_name = libraries[lib]
	else :
		lib_name = Utiles.get_resource_name(lib)
	
	return lib_name + "/" + anim_name

func print_all_connections() -> void:
	print("Connections:")
	for connection in anim_connect_list.connections:
		connection.print_connection()
	print("-----")

## ONE SHOT ##

func request_one_shot(one_shot: String, request: AnimationNodeOneShot.OneShotRequest) -> void:
	animation_tree.set("parameters/%s/request" % one_shot, request)

func is_one_shot_active(one_shot: String) -> bool:
	return animation_tree.get("parameters/%s/active" % one_shot)

## ADD ##

func set_add_amount(add_node_name: StringName, amount: float) -> void:
	amount = max(min(amount, 1.0), 0.0)
	animation_tree.set("parameters/%s/add_amount" %add_node_name, amount)

func tween_add_amount(add_node_name: StringName, duration: float, amount: float= 1.0, tw_ease := Tween.EASE_IN, tw_trans := Tween.TRANS_LINEAR) -> void:
	var tween_add: Tween= create_tween()
	tween_add.set_ease(tw_ease).set_trans(tw_trans)
	var parameter_path: NodePath= NodePath("parameters/%s/add_amount" %add_node_name)
	
	tween_add.tween_property(animation_tree, parameter_path, amount, duration)

func get_add_amount(add_node_name: StringName) -> float:
	return animation_tree.get("parameters/%s/add_amount" %add_node_name)

## GETTER ##
func get_animation_traks(anime: Animation) -> Array[NodePath]:
	var properties: Array[NodePath]
	
	for i in anime.get_track_count():
		var prop_path: NodePath= anime.track_get_path(i)
		properties.append(prop_path)
	
	return properties

func get_animation_node_name(anime: AnimationNode) -> StringName:
	for anim_name in tree_root.get_node_list():
		if tree_root.get_node(anim_name) == anime:
			return anim_name
	return ""

func get_animation_node(anim_name: StringName) -> AnimationNode:
	return tree_root.get_node(anim_name)

func get_animation_name(anim_node: StringName) -> StringName:
	var anime: AnimationNodeAnimation= tree_root.get_node(anim_node)
	return anime.animation

func get_libraries() -> Array[AnimationLibrary]:
	var libraries_array: Array[AnimationLibrary]
	
	for librarie in libraries.keys():
		libraries_array.append(librarie)
	
	return libraries_array

func get_connection_with_from(from: StringName) -> AnimationConnection:
	for connection in anim_connect_list.connections:
		if connection.from == from:
			return connection
	return null

func get_connection_with_to_and_port(to: StringName, port: int) -> AnimationConnection:
	for connection in anim_connect_list.connections:
		if connection.to == to and connection.to_port == port:
			return connection
	return null

func get_connections_with_to(to: StringName) -> Array[AnimationConnection]:
	var connections: Array[AnimationConnection]= []
	
	for connection in anim_connect_list.connections:
		if connection.to == to:
			connections.append(connection)
	
	return connections

func get_all_connections(anim_node_name: StringName) -> Array[AnimationConnection]:
	var connections: Array[AnimationConnection]= []
	
	var from_connection := get_connection_with_from(anim_node_name)
	if from_connection: connections.append(from_connection)
	
	connections += get_connections_with_to(anim_node_name)
	
	return connections
