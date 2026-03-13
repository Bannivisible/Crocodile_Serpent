extends State
class_name AttackState

enum INPUT_MODE{
	PUSH,
	CONTINUE,
	RELEASE,
	BRIEFLY
}


@export var idle_state: State

@export_group("Input")

@export var input_name: String= "attack"
@export var input_time_interval := Vector2.ONE * -1
@export var input_mode := INPUT_MODE.PUSH

@export_group("HitBox")

@export var hit_box: HitBox
@export var attack_data: AttackData
@export_range(0.0, 60.0) var damage_interval: float

@export_group("Animation")
@export var animation_manager: AnimationManagerComponent
#@export var anim_node: StringName= "AttackAnimation"
#@export var blend_node_name: StringName= "AttackOneShot"

@export_group("Combo")
@export_range(0.0, 60.0) var combo_cooldown: float
@export var need_hit_box_hit: bool
@export var previous_state: State
@export var await_previous_attack_finished: bool= true

@onready var combo_timer: Timer= _create_combo_timer()

var is_hit_box_hit: bool= false

var input_time: float= 0.0
var input_active: bool= false

var anim_name: StringName

var anim_node_animation_name: StringName
var anim_node_animation: AnimationNodeAnimation

var blend_node_name: StringName
var blend_node: AnimationNode

#### BUILT-IN ####

func _ready() -> void:
	if not animation_manager.is_node_ready(): await animation_manager.ready
	
	animation_manager.animation_finished.connect(_on_animation_manager_animation_finished)
	hit_box.hit.connect(_on_hit_box_hit)
	if combo_timer: combo_timer.timeout.connect(_on_combo_timer_timeout)
	Events.cs_interface_on_screen_changed.connect(_on_Events_cs_interface_on_screen_changed)
	
	_obtain_anim_name()
	
	
	if previous_state is AttackState:
		previous_state.state_exited.connect(_on_previous_state_exit)


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed(input_name):
		#input_pressed = true
	#
	#if Input.is_action_just_released(input_name):
		#match input_mode:
			#"OneShot":
				#input_pressed = false
				#if is_input_timer_in_interval():
					#_combo_logic()
				#input_time = 0.0
			#
			#"Continue":
				#if is_current_state():
					#_set_idle_state()
	#
	#if Input.is_action_pressed(input_name) and input_mode == "Continue":
		#if is_input_timer_in_interval():
			#input_pressed = false
			#input_time = 0.0
			#_combo_logic()
#
#
#func _physics_process(delta: float) -> void:
	#if input_pressed:
		#input_time += delta


func _physics_process(delta: float) -> void:
	_input_logic(delta)


#### INHERITANCE ####

func enter() -> void:
	_update_hit_box()
	
	if previous_state is AttackState:
		previous_state.is_hit_box_hit = false

#### LOGICS ####

### COMBO ###
func _combo_logic() -> void:
	if previous_state is AttackState:
		if _await_previous_attack_condition():
			await animation_manager.animation_finished
	
		elif not is_combo_cooldown_running(): return
	
	elif not previous_state.is_current_state():
		return
	
	if _combo_condition_valid():
		state_machine.current_state = self


func _await_previous_attack_condition() -> bool:
	var a: bool= previous_state.is_attack_currently_playing()
	var b: bool= await_previous_attack_finished
	
	return a and b


func _combo_condition_valid() -> bool:
	if previous_state is AttackState and need_hit_box_hit:
		return previous_state.is_hit_box_hit
	
	return true


### INPUT ###
func _input_logic(delta) -> void:
	if not input_active: return
	
	if Input.is_action_just_pressed(input_name):
		_input_just_pressed()
	
	if Input.is_action_pressed(input_name):
		input_time += delta
		_input_pressed()
	
	elif Input.is_action_just_released(input_name):
		input_time = 0.0
		_input_release()


func _input_just_pressed() -> void:
	match input_mode:
		INPUT_MODE.BRIEFLY: _combo_logic()


func _input_pressed() -> void:
	match input_mode:
		INPUT_MODE.PUSH:
			if is_input_time_in_interval(): _combo_logic()
		INPUT_MODE.CONTINUE:
			if is_input_time_in_interval(): _combo_logic()


func _input_release() -> void:
	match input_mode: 
		INPUT_MODE.CONTINUE:
			if is_current_state(): _set_idle_state()
		INPUT_MODE.RELEASE:
			if is_input_time_in_interval(): _combo_logic()


func is_input_time_in_interval() -> bool:
	return not is_input_time_under_interval() and not is_input_time_upper_interval()


func is_input_time_under_interval() -> bool:
	if sign(input_time_interval.x) == -1:
		return false
	else :
		return input_time < input_time_interval.x


func is_input_time_upper_interval() -> bool:
	if sign(input_time_interval.y) == -1:
		return false
	else :
		return input_time > input_time_interval.y

################
func _update_hit_box() -> void:
	hit_box.attack_data = attack_data
	hit_box.damage_inteval = damage_interval


func is_attack_currently_playing() -> bool:
	if blend_node == null:
		_obtain_anim_nodes()
		if blend_node == null: return false
	
	if anim_node_animation.animation != anim_name: return false
	
	if blend_node is AnimationNodeOneShot:
		return animation_manager.is_one_shot_active(blend_node_name)
	
	elif blend_node is AnimationNodeBlend2 or blend_node is AnimationNodeBlend3:
		return animation_manager.get_blend_amount(blend_node_name) != 0.0
	
	else :
		return animation_manager.get_current_animation_name() == anim_name


func _obtain_anim_nodes() -> void:
	anim_node_animation_name = animation_manager.get_animation_node_name_with_anim_name(anim_name)
	if anim_node_animation_name == "": return
	
	anim_node_animation = animation_manager.get_animation_node(anim_node_animation_name)
	
	blend_node_name = animation_manager.get_anim_node_connect_to(anim_node_animation_name)
	blend_node = animation_manager.get_animation_node(blend_node_name)


#func _config_animation() -> void:
	#if not animation_manager: return
	#
	#animation_manager.change_animation(anim_node, anim_name)
	#animation_manager.set_filter_with_all_track(blend_node_name, anim_node)


#func _config_anim_connection() -> void:
	#var anim_connection := animation_manager.get_connection_with_from(anim_node)
	#if anim_connection:
		#animation_manager.convert_all_connections(anim_connection.to, blend_node_name)
	#else :
		#animation_manager.connect_animation_node(anim_node, 1, blend_node_name)
#
#
#func _obtain_animation_name_with_lib(name_of_anime: StringName) -> StringName:
	#return animation_manager.add_library_to_name(name_of_anime)


func _set_idle_state() -> void:
	get_top_state_machine().set_state(idle_state)


func is_combo_cooldown_running() -> bool:
	if not combo_timer: return true
	return not combo_timer.is_stopped()


#### SIGNALS RESPONSES ####

#func _on_animation_manager_animation_finished(anime: StringName) -> void:
	#if anime == anim_name:
		#if is_current_state():
			#_set_idle_state()
		#
		#if combo_timer:
			#combo_timer.timeout.emit()
			#combo_timer.stop()
		#
		#if previous_state is AttackState:
			#previous_state.is_hit_box_hit = false
	#
	#elif previous_state is AttackState:
		#if anime == previous_state.anim_name and combo_timer:
			#combo_timer.start()


func _create_combo_timer() -> Timer:
	if combo_cooldown <= 0.0: return null
	if combo_timer: combo_timer.queue_free()
	
	var timer = Timer.new()
	timer.wait_time = combo_cooldown
	timer.one_shot = true
	add_child(timer)
	return timer


func _obtain_anim_name() -> void:
	anim_name = get_chained_string().substr(len(get_top_state_machine().name)+1)
	if animation_manager:
		anim_name = animation_manager.get_anime_complete_name(anim_name)



#### SIGNALS RESPONSES ####
func _on_animation_manager_animation_finished(anime: StringName) -> void:
	if not anime == anim_name: return
	
	if is_current_state(): _set_idle_state()
	
	if combo_timer:
		combo_timer.timeout.emit()
		combo_timer.stop()


func _on_previous_state_exit() -> void:
	if combo_timer: combo_timer.start()


func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	if hit_box.attack_data == attack_data:
		is_hit_box_hit = true


func _on_combo_timer_timeout() -> void:
	pass


func _on_Events_cs_interface_on_screen_changed(on_screen: bool) -> void:
	input_active = !on_screen
