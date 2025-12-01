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

func _input(_event: InputEvent) -> void:
	if not next_attack: return
	
	if Input.is_action_just_pressed(next_attack.input_name):
		var lib: AnimationLibrary= animation_manager.get_libraries()[0]
		var anime: StringName= animation_manager.add_library_to_name(anim_name, lib)
		
		prints(anime, animation_manager.get_current_animation_name())
		
		if animation_manager.get_current_animation_name() == anime:
			await animation_manager.animation_finished
		
		elif invalid_combo_condition():
			return
		
		state_machine.current_state = next_attack

#### INIT ####

func _obtain_hit_box_path() -> String:
	return "HitBox"

func _create_combo_timer() -> Timer:
	if combo_cooldown <= 0.0: return null
	
	var timer = Timer.new()
	timer.wait_time = combo_cooldown
	timer.one_shot = true
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

func invalid_combo_condition() -> bool:
	return not next_attack.is_combo_cooldown_running() or not is_hit_box_hit and need_hit_box_hit

#### SIGNALS RESPONSES ####

func _on_animation_manager_animation_finished(anime: StringName) -> void:
	if anime == anim_name and next_attack:
		next_attack.combo_timer.start()
	
		state_machine.set_state_with_string(idle_state_name)

func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	is_hit_box_hit = true

func _on_next_attack_combo_timer_timeout() -> void:
	is_hit_box_hit = false
