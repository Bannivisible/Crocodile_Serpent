extends StateMachine

@onready var timer: Timer = $Timer

var tween: Tween
@export var APPEAR_ANIMMATION_DURATION: float= 0.25

@export var ease_type: Tween.EaseType
@export var trans_type: Tween.TransitionType

@onready var spell: GeyserSpell= owner
@onready var damage_interval: Timer = $DamageInterval

@onready var animation_state_machine: StateMachine = $"../../AnimationStateMachine"

var target_lenght: float

var ratio: float= 1.0

var colider: HurtBox

#### INHERITANCE ####
func enter() -> void:
	timer.wait_time = spell.duration * ratio
	timer.start()
	
	target_lenght = spell.range_max * ratio
	
	_tween_target_lenght(target_lenght)
	tween.tween_callback(func(): spell.ray_cast_2d.force_raycast_update())


func update(_delta: float) -> void:
	_update_collide_lenght()


func exit() -> void:
	damage_interval.stop()
	
	_tween_target_lenght(0.0)
	tween.tween_callback(func():
		spell.state_machine.set_state_with_string("Desactivate"))
	
	animation_state_machine.set_state_with_string("Void")


#### LOGIC ####
func _tween_target_lenght(lenght: float) -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(ease_type).set_trans(trans_type)
	tween.parallel().tween_property(spell, "target_lenght", lenght, APPEAR_ANIMMATION_DURATION)


func _update_collide_lenght() -> void:
	var ray_cast: RayCast2D = spell.ray_cast_2d
	
	if ray_cast.is_colliding():
		var collision_lenght: float= spell.global_position.distance_to(ray_cast.get_collision_point())
		if collision_lenght != spell.target_lenght:
			if tween: tween.kill()
			spell.target_lenght = collision_lenght
		
		_on_ray_cast_collide(ray_cast.get_collider())
	
	elif spell.target_lenght != target_lenght:
		_tween_target_lenght(target_lenght)
		colider = null


func _on_ray_cast_collide(ray_cast_colider: Node2D) -> void:
	if not ray_cast_colider is HurtBox: return
	if colider == ray_cast_colider: return
	
	colider = ray_cast_colider
	damage_interval.start()


func _hit_colider() -> void:
	spell.hit_box._on_area_2d_entered(colider)


#### SIGNALS RESPONSES ####
func _on_timer_timeout() -> void:
	spell.state_machine.current_state = null


func _on_damage_interval_timeout() -> void:
	if colider: _hit_colider()
