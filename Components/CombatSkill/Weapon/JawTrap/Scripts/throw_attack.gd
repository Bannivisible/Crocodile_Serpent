extends AttackState

@export_range(0.0, 999.9) var distance: float= 50.0
@export_range(0.0, 10.0, 0.1) var time: float
@export var tw_ease: Tween.EaseType
@export var tw_trans: Tween.TransitionType

@onready var front: StaticBody2D = $"../../../Front"

var tween: Tween
var hit_box_tween: Tween


#### INHERITENCE ####
func enter() -> void:
	super.enter()
	
	var pos: Vector2= owner.global_position
	owner.set_as_top_level(true)
	owner.global_position = pos


#### LOGIC ####
func throw() -> void:
	if not is_current_state(): return
	
	if tween: tween.kill()
	if hit_box_tween: hit_box_tween.kill()
	
	var dir := _get_direction()
	_update_rotation(dir)
	
	var dest := _get_destination(dir)
	
	tween = create_tween()
	tween.set_ease(tw_ease).set_trans(tw_trans)
	tween.tween_property(front, "global_position", dest, time)
	
	var collision_shape: CollisionShape2D= hit_box.get_child(0)
	hit_box_tween = create_tween()
	hit_box_tween.set_ease(tw_ease).set_trans(tw_trans)
	hit_box_tween.tween_property(collision_shape, "global_position", dest, time)


func _get_direction() -> Vector2:
	return Utiles.get_joy_dir(Vector2.RIGHT)


func _get_destination(dir: Vector2) -> Vector2:
	var dest := front.global_position
	dest += dir * distance
	
	return dest


func _update_rotation(dir: Vector2) -> void:
	var rot = dir.angle()
	front.rotation = rot

