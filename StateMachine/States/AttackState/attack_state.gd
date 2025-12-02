extends State
class_name AttackState

@export var input_name: String= "attack"

@export var idle_state_name: String= "Idle"

@export_group("HitBox")

@export var hit_box_path: NodePath= _obtain_hit_box_path()
@export var attack_data: AttackData

@export_group("Animation")
@export var anim_manager_path: NodePath= "AnimationManagerComponent"
@export var anim_name: StringName= name
@export var anim_node: StringName= "Attack"
@export var one_shot_node: StringName= "OneShot"

@export_group("Combo")

@export_range(0.0, 20.0) var combo_cooldown: float
@export var next_attack: AttackState
@export var need_hit_box_hit: bool


@onready var animation_manager: AnimationManagerComponent= owner.get_node_or_null(anim_manager_path)
@onready var hit_box: HitBox= owner.get_node_or_null(hit_box_path)

@onready var combo_timer = _create_combo_timer()

var is_hit_box_hit: bool= false

#### BUILT-IN ####

func _ready() -> void:
	if not anim_name: anim_name= name
	
	if animation_manager:
		animation_manager.animation_finished.connect(_on_animation_manager_animation_finished)
	
	if need_hit_box_hit and hit_box:
		hit_box.hit.connect(_on_hit_box_hit)
	
	if next_attack:
		var next_attk_com_timer: Timer= next_attack.combo_timer
		if next_attk_com_timer:
			next_attk_com_timer.timeout.connect(_on_next_attack_combo_timer_timeout)
		#next_attack.hit_box.hit.connect(_on_next_attack_hit_box_hit)

func _input(_event: InputEvent) -> void:
	if not next_attack: return
	
	if Input.is_action_just_pressed(next_attack.input_name):
		var anim_node_anime: AnimationNodeAnimation = animation_manager.get_animation_node(anim_node)
		var lib: AnimationLibrary= animation_manager.get_libraries()[0]
		var anime_name: StringName= animation_manager.add_library_to_name(anim_name, lib)
		
		if anim_node_anime.animation == anime_name and animation_manager.is_one_shot_active(one_shot_node):
			await animation_manager.animation_finished
		
		elif not next_attack.is_combo_cooldown_running():
			return
		
		if combo_condition_valid():
			state_machine.current_state = next_attack

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
		animation_manager.request_one_shot(one_shot_node, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func exit() -> void:
	is_hit_box_hit = false

#### LOGICS ####
func _config_animation() -> void:
	if not animation_manager: return
	
	var lib: AnimationLibrary= animation_manager.get_libraries()[0]
	var anime: StringName= animation_manager.add_library_to_name(anim_name, lib)
	
	animation_manager.change_animation(anim_node, anime)
	animation_manager.set_filter_with_all_track(one_shot_node, anim_node)

func combo_condition_valid() -> bool:
	if need_hit_box_hit:
		return is_hit_box_hit
	return true

#### SIGNALS RESPONSES ####

func _on_animation_manager_animation_finished(anime: StringName) -> void:
	var lib: AnimationLibrary= animation_manager.get_libraries()[0]
	var anime_name: StringName= animation_manager.add_library_to_name(anim_name, lib)
	
	if anime == anime_name:
		if next_attack:
			if next_attack.combo_timer: next_attack.combo_timer.start()
		if combo_timer: combo_timer.stop()
		
		state_machine.set_state_with_string(idle_state_name)

func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	if hit_box.attack_data == attack_data:
		is_hit_box_hit = true

func _on_next_attack_combo_timer_timeout() -> void:
	is_hit_box_hit = false

func _on_next_attack_hit_box_hit() -> void:
	if hit_box.attack_data == attack_data:
		is_hit_box_hit = false
