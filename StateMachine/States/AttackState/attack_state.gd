extends State
class_name AttackState

@export var idle_state_name: String= "Idle"

@export_group("Input")

@export var input_name: String= "attack"
@export var input_time_interval := Vector2.ONE * -1
@export_enum("OneShot", "Continue") var input_mode: String= "OneShot"

@export_group("HitBox")

@export var hit_box_path: NodePath= _obtain_hit_box_path()
@export var attack_data: AttackData
@export_range(0.0, 60.0) var damage_interval: float

@export_group("Animation")
@export var anim_manager_path: NodePath= "AnimationManagerComponent"
@export var anim_name: StringName= name
@export var anim_node: StringName= "Attack"
@export var blend_node_name: StringName= "OneShot"

@export_group("Combo")
@export_range(0.0, 60.0) var combo_cooldown: float
@export var need_hit_box_hit: bool
@export var previous_state: State

@onready var animation_manager: AnimationManagerComponent= owner.get_node_or_null(anim_manager_path)
@onready var hit_box: HitBox= owner.get_node_or_null(hit_box_path)

@onready var combo_timer: Timer= _create_combo_timer()

var is_hit_box_hit: bool= false

var input_pressed: bool= false
var input_time: float= 0.0

#### BUILT-IN ####

func _ready() -> void:
	if not anim_name: anim_name= name
	
	if not animation_manager.is_node_ready(): await animation_manager.ready
	anim_name = _obtain_animation_name_with_lib(anim_name)
	
	animation_manager.animation_finished.connect(_on_animation_manager_animation_finished)
	hit_box.hit.connect(_on_hit_box_hit)
	if combo_timer:
		combo_timer.timeout.connect(_on_combo_timer_timeout)
		
	#if next_attack:
		#var next_attk_com_timer: Timer= next_attack.combo_timer
		#if next_attk_com_timer:
			#next_attk_com_timer.timeout.connect(_on_next_attack_combo_timer_timeout)
		
		#if not next_attack.is_node_ready():
			#await next_attack.ready
		#next_attack.hit_box.hit.connect(_on_next_attack_hit_box_hit)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed(input_name):
		input_pressed = true
	
	if Input.is_action_just_released(input_name):
		match input_mode:
			"OneShot":
				input_pressed = false
				if is_input_timer_in_interval():
					_combo_logic()
				input_time = 0.0
			
			"Continue":
				state_machine.set_state_with_string(idle_state_name)
	
	if Input.is_action_pressed(input_name) and input_mode == "Continue":
		if is_input_timer_in_interval():
			input_pressed = false
			input_time = 0.0
			_combo_logic()

func _physics_process(delta: float) -> void:
	if input_pressed:
		input_time += delta

func is_input_timer_in_interval() -> bool:
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

#### INIT ####

func _obtain_hit_box_path() -> String:
	return "HitBox"

func _create_combo_timer() -> Timer:
	if combo_cooldown <= 0.0: return null
	
	var timer = Timer.new()
	timer.wait_time = combo_cooldown
	timer.one_shot = true
	add_child(timer)
	return timer

#func _obtain_previous_state() -> State:
	#
	#return state_machine.get_node_or_null(idle_state_name)

#### INHERITANCE ####

func enter() -> void:
	_update_hit_box()
	_update_animation_tree()

func exit() -> void:
	if blend_node_name:
		pass

func _update_hit_box() -> void:
	hit_box.attack_data = attack_data
	hit_box.damage_inteval = damage_interval

func _update_animation_tree() -> void:
	_config_animation()
	_config_anim_connection()
	
	var blend_node: AnimationNode= animation_manager.get_animation_node(blend_node_name)
	
	if blend_node is AnimationNodeOneShot:
		animation_manager.request_one_shot(blend_node_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	elif blend_node is AnimationNodeAdd2:
		animation_manager.set_add_amount(blend_node_name, 1.0)

#### LOGICS ####
#func _input_condition() -> bool:
	#match input_mode:
		#"Pressed": return Input.is_action_just_pressed(input_name)
		#"Realease": return Input.is_action_just_released(input_name) 
	#return false

func _combo_logic() -> void:
	if previous_state is AttackState:
		var prev_attack: AttackState= previous_state
		
		if prev_attack.is_attack_currently_playing():
			await animation_manager.animation_finished
		elif not is_combo_cooldown_running(): return 
	
	elif not previous_state.is_current_state():
		return
	
	if _combo_condition_valid():
		state_machine.current_state = self

func _combo_condition_valid() -> bool:
	if previous_state is AttackState and need_hit_box_hit:
		return previous_state.is_hit_box_hit
	return true

func is_attack_currently_playing() -> bool:
	var anim_node_anime: AnimationNodeAnimation = animation_manager.get_animation_node(anim_node)
	var blend_node: AnimationNode= animation_manager.get_animation_node(blend_node_name)
	
	if blend_node is AnimationNodeOneShot:
		return anim_node_anime.animation == anim_name and animation_manager.is_one_shot_active(blend_node_name)
	
	elif blend_node is AnimationNodeAdd2 or blend_node is AnimationNodeAdd3:
		return anim_node_anime.animation == anim_name and animation_manager.get_add_amount(blend_node_name) != 0.0
	
	else :
		return animation_manager.get_current_animation_name() == anim_name

func _config_animation() -> void:
	if not animation_manager: return
	
	animation_manager.change_animation(anim_node, anim_name)
	animation_manager.set_filter_with_all_track(blend_node_name, anim_node)

func _config_anim_connection() -> void:
	var anim_connection := animation_manager.get_connection_with_from(anim_node)
	if anim_connection:
		animation_manager.convert_all_connections(anim_connection.to, blend_node_name)
	else :
		animation_manager.connect_animation_node(anim_node, 1, blend_node_name)

func _obtain_animation_name_with_lib(name_of_anime: StringName) -> StringName:
	var lib: AnimationLibrary= animation_manager.get_libraries()[0]
	var anime_name: StringName= animation_manager.add_library_to_name(name_of_anime, lib)
	return anime_name

func is_combo_cooldown_running() -> bool:
	if not combo_timer: return true
	return not combo_timer.is_stopped()

#### SIGNALS RESPONSES ####

func _on_animation_manager_animation_finished(anime: StringName) -> void:
	if anime == anim_name:
		state_machine.set_state_with_string(idle_state_name)
		
		if combo_timer:
			combo_timer.timeout.emit()
			combo_timer.stop()
		
		if previous_state is AttackState:
			previous_state.is_hit_box_hit = false
	
	elif previous_state is AttackState:
		if anime == previous_state.anim_name and combo_timer:
			combo_timer.start()

func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	if hit_box.attack_data == attack_data:
		is_hit_box_hit = true

func _on_combo_timer_timeout() -> void:
	pass

#func _on_next_attack_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	#if hit_box.attack_data == next_attack.attack_data:
		#is_hit_box_hit = false
