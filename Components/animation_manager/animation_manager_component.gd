extends Component
class_name AnimationManagerComponent

const EXIT_ANIM_NAME: StringName= "EXIT"

@export var anim_player_path: NodePath= "AnimationPlayer"
@export var anim_tree_path: NodePath= "AnimationTree"

@onready var animation_player: AnimationPlayer= get_object_node(anim_player_path)
@onready var animation_tree: AnimationTree= get_object_node(anim_tree_path)
@onready var tree_root: AnimationNodeBlendTree= animation_tree.tree_root if animation_tree else null

@export var reset_anim_name: StringName= "RESET"

@export var anim_connect_list: AnimationConnectionsList

@export var library: AnimationLibrary:
	set = _set_library

@export var remove_library_on_exit_tree: bool= true

var tracks_filter: Dictionary[StringName, Array]= {}

signal animation_finished(anim_name: StringName)

var blend_tween: Tween

#### SETTER ####
func _set_library(value) -> void:
	library = value
	
	if not is_node_ready(): await ready 
	
	if library != null:
		#add_library(library)
		add_all_anim_library(library, animation_player.get_animation_library(""))


#### BUILT-IN ####
func _ready() -> void:
	var on_animation_finished: Callable= func(anim_name: StringName): animation_finished.emit(anim_name)
	
	animation_player.animation_finished.connect(on_animation_finished)
	animation_tree.animation_finished.connect(on_animation_finished)


func _enter_tree() -> void:
	if not is_node_ready(): await ready 
	
	if remove_library_on_exit_tree and library != null:
		add_all_anim_library(library, animation_player.get_animation_library(""))


func _exit_tree() -> void:
	if remove_library_on_exit_tree and library != null and not has_animation(EXIT_ANIM_NAME):
		reset_tree_with_lib()
		remove_all_anim_library(library, animation_player.get_animation_library(""))

#### LOGIC ####
#func add_library(anim_lib: AnimationLibrary, lib_name :=StringName(Utiles.get_resource_name(anim_lib))) -> void:
	#if not animation_player.has_animation_library(lib_name):
		#animation_player.add_animation_library(lib_name, anim_lib)
#
#
#func remove_library(lib_name: StringName) -> void:
	#if animation_player.has_animation_library(lib_name):
		#animation_player.remove_animation_library(lib_name)

## PUBLIC ##
func is_animation_playing(anim_name: StringName) -> bool:
	if animation_player.current_animation == anim_name:
		return true
	
	
	
	return false


func add_all_anim_library(lib_from: AnimationLibrary, lib_to: AnimationLibrary) -> void:
	for anim_name in lib_from.get_animation_list():
		var anim: Animation= library.get_animation(anim_name)
		lib_to.add_animation(anim_name, anim)


func remove_all_anim_library(lib_from: AnimationLibrary, lib_to: AnimationLibrary) -> void:
	for anim_name in lib_from.get_animation_list():
		if lib_to.has_animation(anim_name):
			lib_to.remove_animation(anim_name)


func play(anim_name: StringName) -> void:
	animation_player.play(anim_name)


func get_current_animation_name() -> String:
	return animation_player.current_animation


func play_reset_anim_name() -> void:
	if animation_player.has_animation(reset_anim_name):
		play(reset_anim_name)


func has_animation(anim_name: StringName) -> bool:
	return animation_player.has_animation(anim_name)

### ANIM NODE ####

### BlendTree ###
func setup_one_shot(one_shot_name: StringName, new_anim_name: StringName, filter_anim_name := new_anim_name) -> void:
	var anim_node_name: StringName= get_connection_with_to_and_port(one_shot_name, 1).from
	
	change_filter(one_shot_name, get_animation(filter_anim_name))
	change_animation(anim_node_name, new_anim_name)
	request_one_shot(one_shot_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func setup_blend_node(blend_nd_name: StringName, new_anim_name: StringName, filter_anim_name := new_anim_name) -> void:
	var anim_node_name: StringName= get_connection_with_to_and_port(blend_nd_name, 1).from
	
	change_filter(blend_nd_name, get_animation(filter_anim_name))
	change_animation(anim_node_name, new_anim_name)
	set_blend_amount(blend_nd_name, 1.0)


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


func set_filter_with_all_track(blend_nd_name: StringName, anim: Animation, activate: bool= true, anim_player := animation_player) -> void:
	var blend_node: AnimationNode= tree_root.get_node(blend_nd_name)
	
	if activate:
		if tracks_filter.has(blend_nd_name):
			tracks_filter[blend_nd_name].append(anim)
		else :
			tracks_filter[blend_nd_name] = [anim]
	else :
		tracks_filter[blend_nd_name] = []
	
	for i in anim.get_track_count():
		var track_path: NodePath= anim.track_get_path(i)
		blend_node.set_filter_path(track_path, activate)
		
		if anim.track_get_type(i) == Animation.TrackType.TYPE_ANIMATION:
			for key_idx in anim.track_get_key_count(i):
				var sub_anim_name = anim.track_get_key_value(i, key_idx)
				var sub_anim_player: AnimationPlayer= anim_player.get_node(animation_player.root_node).get_node(track_path)
				var sub_anim: Animation= sub_anim_player.get_animation(sub_anim_name)
				
				set_filter_with_all_track(blend_nd_name, sub_anim, activate, sub_anim_player)
	
	blend_node.filter_enabled = activate



func verif_filter(blend_nd_name: StringName, anime: Animation) -> Dictionary[NodePath, bool]:
	var dict: Dictionary[NodePath, bool]
	
	var blend_node: AnimationNode= tree_root.get_node(blend_nd_name)
	
	for prop_path in get_animation_traks(anime):
		dict[prop_path] = blend_node.is_path_filtered(prop_path)
	
	return dict


func reset_filter(blend_nd_name: StringName) -> void:
	if not tracks_filter.has(blend_nd_name) or tracks_filter[blend_nd_name] == null: return
	for anim in tracks_filter[blend_nd_name]:
		set_filter_with_all_track(blend_nd_name, anim, false)


func change_filter(blend_nd_name: StringName, anim: Animation) -> void:
	if tracks_filter.has(blend_nd_name) and is_filtred_by(blend_nd_name, anim): return
	reset_filter(blend_nd_name)
	
	if anim.get_track_count() != 0:
		set_filter_with_all_track(blend_nd_name, anim)


func is_filtred_by(blend: String, anim: Animation) -> bool:
	return anim in tracks_filter[blend]


func change_animation(anim_node_name: StringName, anim_name: StringName) -> void:
	var anim_node := get_animation_node(anim_node_name)
	
	if anim_node is AnimationNodeAnimation:
		anim_node.animation = anim_name
	elif anim_node is AnimationNodeStateMachine:
		travel_animation(anim_node_name, anim_name)


func convert_all_connections(anim_nd_name1: StringName, anim_nd_name2: StringName) -> void:
	var nd1_from_connection: AnimationConnection= get_connection_with_from(anim_nd_name1)
	if nd1_from_connection:
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


#func add_library_to_name(anim_name: StringName, lib: AnimationLibrary= library) -> StringName:
	#var lib_name: StringName = Utiles.get_resource_name(lib)
	#
	#return lib_name + "/" + anim_name


func print_all_connections() -> void:
	print("Connections:")
	for connection in anim_connect_list.connections:
		connection.print_connection()
	print("-----")


#func is_anim_in_tree(anim_name: String) -> bool:
	#return anim_name in get_all_current_anim_name_in_tree()

## ONE SHOT ##
func request_one_shot(one_shot_name: String, request:= AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE) -> void:
	animation_tree.set("parameters/%s/request" % one_shot_name, request)


func get_request_one_shot(one_shot_name: String) -> AnimationNodeOneShot.OneShotRequest:
	return animation_tree.get("parameters/%s/request" % one_shot_name)


func is_one_shot_active(one_shot: String) -> bool:
	return animation_tree.get("parameters/%s/active" % one_shot)

## BLEND ##
func set_blend_amount(blend_node_name: StringName, amount: float) -> void:
	amount = max(min(amount, 1.0), 0.0)
	animation_tree.set("parameters/%s/blend_amount" %blend_node_name, amount)


func tween_blend_amount(blend_node_name: StringName, duration: float, amount: float= 1.0, tw_ease := Tween.EASE_IN, tw_trans := Tween.TRANS_LINEAR) -> void:
	blend_tween = Utiles.reset_tween(self, blend_tween, tw_ease, tw_trans)
	var parameter_path: NodePath= NodePath("parameters/%s/blend_amount" %blend_node_name)
	
	blend_tween.tween_property(animation_tree, parameter_path, amount, duration)


func get_blend_amount(blend_node_name: StringName) -> float:
	return animation_tree.get("parameters/%s/blend_amount" %blend_node_name)

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
func get_anim_nd_name(anim_node: AnimationNode) -> StringName:
	for anim_nd_name in tree_root.get_node_list():
		if get_animation_node(anim_nd_name) == anim_node:
			return anim_nd_name
	
	return ""


func get_animation(anim_name: StringName) -> Animation:
	if animation_player.has_animation(anim_name):
		return animation_player.get_animation(anim_name)
	return null


func get_animation_traks(anime: Animation) -> Array[NodePath]:
	var properties: Array[NodePath]= []
	
	if anime == null: return properties
	
	for i in anime.get_track_count():
		var prop_path: NodePath= anime.track_get_path(i)
		properties.append(prop_path)
	
	return properties


func get_animation_node_name(anime: AnimationNode) -> StringName:
	for anim_name in tree_root.get_node_list():
		if tree_root.get_node(anim_name) == anime:
			return anim_name
	return ""


func get_animation_node(anim_node_name: StringName) -> AnimationNode:
	return tree_root.get_node(anim_node_name)


func get_animation_node_name_with_anim_name(anim_name: StringName) -> StringName:
	for anim_node_name in get_all_anim_node_animation_name():
		var anim_node: AnimationNodeAnimation= get_animation_node(anim_node_name)
		
		if anim_node.animation == anim_name: return anim_node_name
	
	return ""


func get_all_anim_node_name() -> Array[StringName]:
	return tree_root.get_node_list()


func get_all_anim_node_animation_name() -> Array[StringName]:
	var anim_node_animation_array: Array[StringName]
	
	for anim_node_name in get_all_anim_node_name():
		var anim_node := get_animation_node(anim_node_name)
		
		if anim_node is AnimationNodeAnimation:
			anim_node_animation_array.append(anim_node_name)
	
	return anim_node_animation_array


func get_animation_name_of_node(anim_node: AnimationNode) -> StringName:
	if anim_node is AnimationNodeAnimation:
		return anim_node.animation
	
	elif anim_node is AnimationNodeStateMachine:
		return get_anim_state_machine_current_anim_name(get_anim_nd_name(anim_node))
	
	return ""


func get_animation_name_of(anim_node_name: StringName, anim_nd_parent: AnimationNode= tree_root) -> StringName:
	var anim_node : AnimationNode= anim_nd_parent.get_node(anim_node_name)
	if anim_node is AnimationNodeAnimation:
		return anim_node.animation
	
	elif anim_node is AnimationNodeStateMachine:
		return get_anim_state_machine_current_anim_name(anim_node_name)
	
	return ""


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


func get_anim_node_connect_to(anim_node_name: StringName) -> StringName:
	var connection: AnimationConnection= get_connection_with_from(anim_node_name)
	return connection.to


func get_anim_node_connect_in(anim_node_name: StringName) -> StringName:
	return get_connection_with_to_and_port(anim_node_name, 0).from


#func get_anime_complete_name(anim_name: StringName) -> StringName:
	#if library.has_animation(anim_name):
		#return add_library_to_name(anim_name)
	#return anim_name


func get_current_anim_names() -> Array[StringName]:
	var anim_names: Array[StringName]
	
	for anim_node_name in tree_root.get_node_list():
		var anim_node := get_animation_node(anim_node_name)
		
		if anim_node is AnimationNodeAnimation:
			anim_names.append(anim_node.animation)
		elif anim_node is AnimationNodeStateMachine:
			var anim_name := get_anim_state_machine_current_anim_name(anim_node_name)
			anim_names.append(anim_name)
	
	return anim_names


func get_string_all_current_anim_name_in_tree() -> Array[String]:
	var anim_list: Array[String]= []
	
	for anim_node_name in tree_root.get_node_list():
		var anim_node := tree_root.get_node(anim_node_name)
		
		if anim_node is AnimationNodeAnimation:
			var string: String= anim_node_name + " : " + get_animation_name_of(anim_node_name)
			
			anim_list.append(string)
	
	return anim_list


### STATE MACHINE PLAYBACK ###
func get_state_machine_playback(anim_state_machine_path: StringName) -> AnimationNodeStateMachinePlayback:
	var path: StringName= "parameters/%s/playback" % anim_state_machine_path
	return animation_tree.get(path)


func get_anim_state_machine_current_anim_node_name(anim_sm_name: StringName) -> StringName:
	var playback := get_state_machine_playback(anim_sm_name)
	
	return playback.get_current_node()


func get_anim_state_machine_current_anim_name(anim_sm_name: StringName) -> StringName:
	var playback := get_state_machine_playback(anim_sm_name)
	
	return get_animation_name_of(playback.get_current_node(), get_animation_node(anim_sm_name))


func travel_animation(anim_sm_name: StringName, anim_name: StringName) -> void:
	var sm_playback := get_state_machine_playback(anim_sm_name)
	sm_playback.travel(anim_name)


func reset_anim_node(anim_node_name: StringName) -> void:
	var anim_node := get_animation_node(anim_node_name)
	
	if anim_node is AnimationNodeAnimation:
		change_animation(anim_node_name, reset_anim_name)
	elif anim_node is AnimationNodeBlend2 or anim_node is AnimationNodeBlend3:
		set_blend_amount(anim_node_name, 0.0)
		reset_filter(anim_node_name)
	
	elif anim_node is AnimationNodeOneShot:
		request_one_shot(anim_node_name ,AnimationNodeOneShot.ONE_SHOT_REQUEST_NONE)
		reset_filter(anim_node_name)


func print_blendtree() -> void:
	print("BlendTree:")
	
	for anim_node_name in tree_root.get_node_list():
		var anim_node = get_animation_node(anim_node_name)
		
		if anim_node is AnimationNodeAnimation:
			print_animation_node(anim_node_name)
		elif anim_node is AnimationNodeBlend2 or anim_node is AnimationNodeBlend3:
			print_blend_node(anim_node_name)
		elif anim_node is AnimationNodeOneShot:
			print_one_shot_node(anim_node_name)
		elif anim_node is AnimationNodeStateMachine:
			print_anim_state_machine(anim_node_name)
		else : print(anim_node_name)
	
	print("------------")


func print_animation_node(animation_node_name: StringName) -> void:
	print(animation_node_name + " : " + str(get_animation_name_of(animation_node_name)))


func print_blend_node(blend_node_name: StringName) -> void:
	print(blend_node_name + " : " + str(get_blend_amount(blend_node_name)))


func print_one_shot_node(one_shot_node_name: StringName) -> void:
	print(one_shot_node_name + " : " + str(get_request_one_shot(one_shot_node_name)))


func print_anim_state_machine(anim_state_machine_name: StringName) -> void:
	var anim_sm_playback := get_state_machine_playback(anim_state_machine_name)
	print(anim_state_machine_name + " : " +anim_sm_playback.get_current_node())


func change_animations_in_library(new_anim_name := reset_anim_name, lib := library) -> void:
	for anim_node_name in get_all_anim_node_animation_name():
		if lib.has_animation(get_animation_name_of(anim_node_name)):
			change_animation(anim_node_name, new_anim_name)


func reset_tree_with_lib(lib := library) -> void:
	for anim_node_name in get_all_anim_node_animation_name():
		if not lib.has_animation(get_animation_name_of(anim_node_name)): continue
		
		reset_anim_node(anim_node_name)
		var blend_node_name: StringName= get_anim_node_connect_to(anim_node_name)
		reset_anim_node(blend_node_name)

#### SIGNALS RESPONSES ####
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == EXIT_ANIM_NAME and remove_library_on_exit_tree:
		reset_tree_with_lib()
		remove_all_anim_library(library, animation_player.get_animation_library(""))


