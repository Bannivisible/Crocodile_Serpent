extends State

@export var next_state: State

@onready var throw_attack: Node = $"../ThrowAttack"
@onready var back: StaticBody2D = $"../../../Back"

func enter() -> void:
	var tween := create_tween()
	
	tween.set_ease(throw_attack.tw_ease).set_trans(throw_attack.tw_trans)
	tween.tween_property(back, "global_position", throw_attack.front.global_position, throw_attack.time)
	
	tween.tween_callback(func():
		owner.global_position = back.global_position
		get_top_state_machine().set_state(next_state))
