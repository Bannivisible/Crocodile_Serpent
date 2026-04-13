extends State


@export var add_speed_scale: float= 1.0
@export var time_scale_name: StringName

@onready var deflagration: DeflagrationSpell = owner
@onready var animation_manager: AnimationManagerComponent = $"../../AnimationManagerComponent"


func _ready() -> void:
	animation_manager.animation_finished.connect(_on_animation_manager_animation_finished)


func enter() -> void:
	owner.free_player()
	
	var amount: float= animation_manager.get_time_scale_amount(time_scale_name)
	amount += add_speed_scale
	animation_manager.set_time_scale_amount(time_scale_name, amount)


func exit() -> void:
	var amount: float= animation_manager.get_time_scale_amount(time_scale_name)
	amount -= add_speed_scale
	animation_manager.set_time_scale_amount(time_scale_name, amount)

func _on_animation_manager_animation_finished(anim_name: StringName) -> void:
	if anim_name == name:
		deflagration.cast_projectile()
		state_machine.set_state_with_string("Void")
