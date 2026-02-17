extends State

@onready var deflagration: ProjectileDeflagration = owner


func enter() -> void:
	deflagration.collision_shape_2d.disabled = false
	var tween: Tween = deflagration.tween
	
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(deflagration, "scale", deflagration.origine_scale, deflagration.APPEARING_TWEEN_DURATION)


func update(delta: float) -> void:
	deflagration.sprite_2d.rotation += PI * delta
