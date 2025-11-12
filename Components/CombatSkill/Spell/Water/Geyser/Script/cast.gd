extends StateMachine

@onready var timer: Timer = $Timer

var tween: Tween
@export var APPEAR_ANIMMATION_DURATION: float= 0.25

@export var ease_type: Tween.EaseType
@export var trans_type: Tween.TransitionType

@onready var spell: SpellGeyser= owner

var target_lenght: float

func enter() -> void:
	timer.wait_time = spell.duration * spell.context["charge_rate"]
	timer.start()
	
	target_lenght = spell.range_max * spell.context["charge_rate"]
	
	_tween_target_lenght(target_lenght)
	tween.tween_callback(func(): spell.ray_cast_2d.force_raycast_update())


func update(_delta: float) -> void:
	var ray_cast: RayCast2D = spell.ray_cast_2d
	
	if ray_cast.is_colliding():
		
		var collision_lenght: float= spell.global_position.distance_to(ray_cast.get_collision_point())
		if collision_lenght != spell.target_lenght:
			if tween: tween.kill()
			spell.target_lenght = collision_lenght
		
		if ray_cast.get_collider() is HurtBox:
			var hurt_box: HurtBox= ray_cast.get_collider()
			spell.hit_box._on_area_2d_entered(hurt_box)
	
	elif spell.target_lenght != target_lenght:
		_tween_target_lenght(target_lenght)


func exit() -> void:
	_tween_target_lenght(0.0)
	tween.tween_callback(func():
		spell.state_machine.set_state_with_string("Desactivate"))

func _tween_target_lenght(lenght: float) -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(ease_type).set_trans(trans_type)
	tween.parallel().tween_property(spell, "target_lenght", lenght, APPEAR_ANIMMATION_DURATION)


func _on_timer_timeout() -> void:
	spell.state_machine.current_state = null
