extends StateMachine

@onready var timer: Timer = $Timer

var tween: Tween
@export var APPEAR_ANIMMATION_DURATION: float= 0.25

@export var ease_type: Tween.EaseType
@export var trans_type: Tween.TransitionType

@onready var spell: GeyserSpell= owner

@onready var animation_state_machine: StateMachine = $"../../AnimationStateMachine"

var target_lenght: float

var ratio: float= 1.0

#### INHERITANCE ####
func enter() -> void:
	timer.wait_time = spell.duration * ratio
	timer.start()
	
	target_lenght = spell.range_max * ratio
	
	_tween_target_lenght(target_lenght)
	tween.tween_callback(func(): spell.ray_cast_2d.force_raycast_update())


func update(_delta: float) -> void:
	var ray_cast: RayCast2D = spell.ray_cast_2d
	var ray_cast_colider = ray_cast.get_collider()
	
	if ray_cast_colider != null:
		_on_ray_cast_collide(ray_cast_colider)
	else :
		_on_ray_cast_not_collide()


func exit() -> void:
	spell.hit_box.damage_inteval_timer.stop()
	spell.hit_box.overlapping_hurt_box = []
	
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


func _on_ray_cast_collide(ray_cast_colider: Node2D) -> void:
	if not ray_cast_colider is HurtBox: return
	if ray_cast_colider in spell.hit_box.overlapping_hurt_box: return
	if spell.hit_box.faction == ray_cast_colider.get_faction(): return
	
	spell.hit_box.overlapping_hurt_box = [ray_cast_colider]
	spell.hit_box.damage_inteval_timer.start()
	_update_collide_lenght()


func _update_collide_lenght() -> void:
	var ray_cast: RayCast2D = spell.ray_cast_2d
	
	var collision_lenght: float= spell.global_position.distance_to(ray_cast.get_collision_point())
	if collision_lenght != spell.target_lenght:
		if tween: tween.kill()
		spell.target_lenght = collision_lenght


func _on_ray_cast_not_collide() -> void:
	if spell.target_lenght == target_lenght: return
	spell.hit_box.overlapping_hurt_box = []
	spell.hit_box.damage_inteval_timer.stop()
	_update_not_collide_lenght()


func _update_not_collide_lenght() -> void:
	_tween_target_lenght(target_lenght)

#### SIGNALS RESPONSES ####
func _on_timer_timeout() -> void:
	spell.state_machine.current_state = null
