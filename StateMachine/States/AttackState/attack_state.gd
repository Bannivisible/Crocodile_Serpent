extends State
class_name AttackState


@export var idle_state_name: String= "Idle"
@export var input_name: String= "attack"
@export_enum("Pressed", "Realease") var input_mode: String= "Pressed"

#@export_enum("OneShotAttack", "ContinueAttack") var mode: String= "OneShotAttack"

@export_group("HitBox")

@export var hit_box_path: NodePath= _obtain_hit_box_path()
@export var attack_data: AttackData

@export_group("Animation")
@export var anim_manager_path: NodePath= "AnimationManagerComponent"
@export var anim_name: StringName= name
@export var anim_node: StringName= "Attack"
@export var blend_node_name: StringName= "OneShot"

@export_group("Combo")
@export_range(0.0, 60.0) var combo_cooldown: float
@export var need_hit_box_hit: bool
@export var next_attack: AttackState


@onready var animation_manager: AnimationManagerComponent= owner.get_node_or_null(anim_manager_path)
@onready var hit_box: HitBox= owner.get_node_or_null(hit_box_path)

@onready var combo_timer = _create_combo_timer()

var is_hit_box_hit: bool= false

#### BUILT-IN ####

func _ready() -> void:
	if not anim_name: anim_name= name
	
	if animation_manager:
		animation_manager.animation_finished.connect(_on_animation_manager_animation_finished)
	
	hit_box.hit.connect(_on_hit_box_hit)
	
	if next_attack:
		var next_attk_com_timer: Timer= next_attack.combo_timer
		if next_attk_com_timer:
			next_attk_com_timer.timeout.connect(_on_next_attack_combo_timer_timeout)
		
		#if not next_attack.is_node_ready():
			#await next_attack.ready
		#next_attack.hit_box.hit.connect(_on_next_attack_hit_box_hit)

func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_released(input_name) and mode == "ConstinueAttack":
		#state_machine.set_state_with_string(idle_state_name)
	
	if next_attack:
		if next_attack._input_condition():
			_combo_logic()


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

func is_combo_cooldown_running() -> bool:
	if not combo_timer: return true
	return not combo_timer.is_stopped()

#### INHERITANCE ####

func enter() -> void:
	if hit_box:
		hit_box.attack_data = attack_data
	if animation_manager:
		_config_animation()
		
		var blend_node: AnimationNode= animation_manager.get_animation_node(blend_node_name)
		
		if blend_node is AnimationNodeOneShot:
			animation_manager.request_one_shot(blend_node_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		elif blend_node is AnimationNodeAdd2:
			animation_manager.set_add_amount(blend_node_name, 1.0)

#### LOGICS ####
func _input_condition() -> bool:
	match input_mode:
		"Pressed": return Input.is_action_just_pressed(input_name)
		"Realease": return Input.is_action_just_released(input_name) 
	return false

func _combo_logic() -> void:
	if is_attack_currently_playing():
		await animation_manager.animation_finished
	
	elif not next_attack.is_combo_cooldown_running():
		return
	
	if combo_condition_valid():
		state_machine.current_state = next_attack

func is_attack_currently_playing() -> bool:
	var anim_node_anime: AnimationNodeAnimation = animation_manager.get_animation_node(anim_node)
	var anime_name: StringName= _obtain_animation_name_with_lib(anim_name)
	
	return anim_node_anime.animation == anime_name and animation_manager.is_one_shot_active(blend_node_name)

func _config_animation() -> void:
	if not animation_manager: return
	
	var lib: AnimationLibrary= animation_manager.get_libraries()[0]
	var anime: StringName= animation_manager.add_library_to_name(anim_name, lib)
	
	animation_manager.change_animation(anim_node, anime)
	animation_manager.set_filter_with_all_track(blend_node_name, anim_node)

func combo_condition_valid() -> bool:
	if next_attack:
		if next_attack.need_hit_box_hit:
			return is_hit_box_hit
	return true

func _obtain_animation_name_with_lib(name_of_anime: StringName) -> StringName:
	var lib: AnimationLibrary= animation_manager.get_libraries()[0]
	var anime_name: StringName= animation_manager.add_library_to_name(name_of_anime, lib)
	return anime_name

#### SIGNALS RESPONSES ####

func _on_animation_manager_animation_finished(anime: StringName) -> void:
	var anime_name: StringName= _obtain_animation_name_with_lib(anim_name)
	
	if anime == anime_name:
		if next_attack:
			if next_attack.combo_timer: next_attack.combo_timer.start()
		if combo_timer: combo_timer.stop()
		
		state_machine.set_state_with_string(idle_state_name)
	
	elif next_attack:
		anime_name = _obtain_animation_name_with_lib(next_attack.anim_name)
		
		if anime == anime_name:
			is_hit_box_hit = false

func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	if hit_box.attack_data == attack_data:
		is_hit_box_hit = true

func _on_next_attack_combo_timer_timeout() -> void:
	is_hit_box_hit = false

#func _on_next_attack_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	#if hit_box.attack_data == next_attack.attack_data:
		#is_hit_box_hit = false
