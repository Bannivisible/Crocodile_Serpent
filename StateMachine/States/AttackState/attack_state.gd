extends State
class_name AttackState

@export var input_action: InputEventAction= load("res://StateMachine/States/AttackState/base_attack_input_event_action.tres")

@export_group("HitBox")

@export var hit_box: HitBox
@export var attack_data: AttackData

@export_group("Combo")

@export_range(0.0, 20.0) var combo_cool_down: float
@export var next_attack: AttackState
@export var need_hit_box_hurt: bool

@onready var combo_timer = _create_combo_timer()


func enter() -> void:
	hit_box.attack_data = attack_data

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(input_action.action):
		pass

func _create_combo_timer() -> Timer:
	var timer = Timer.new()
	timer.wait_time = combo_cool_down
	timer.one_shot = true
	return timer
