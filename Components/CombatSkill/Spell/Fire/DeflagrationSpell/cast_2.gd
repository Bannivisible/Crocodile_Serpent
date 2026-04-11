extends State


var add_speed_scale: float= 2.0

@onready var deflagration: DeflagrationSpell = owner
@onready var animation_manager: AnimationManagerComponent = $"../../AnimationManagerComponent"


func _ready() -> void:
	animation_manager.animation_finished.connect(_on_animation_manager_animation_finished)


func enter() -> void:
	owner.free_player()
	animation_manager.animation_player.speed_scale += add_speed_scale


func exit() -> void:
	animation_manager.animation_player.speed_scale -= add_speed_scale




func _on_animation_manager_animation_finished(anim_name: StringName) -> void:
	if anim_name == name:
		deflagration.cast_projectile()
		state_machine.set_state_with_string("Void")
