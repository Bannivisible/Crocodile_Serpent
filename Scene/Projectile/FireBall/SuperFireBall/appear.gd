extends State

@onready var super_fb: ProjectileSuperFireBall = owner


func enter() -> void:
	super_fb.collision_shape_2d.disabled = false
	var tween: Tween = super_fb.tween
	
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(super_fb, "scale", super_fb.origine_scale, super_fb.APPEARING_TWEEN_DURATION)
	
	tween.tween_property(super_fb.sprite_2d, "rotation", -TAU, super_fb.ROTATION_ANIMATION_DURATION)
	tween.tween_property(super_fb.sprite_2d, "rotation", TAU, super_fb.ROTATION_ANIMATION_DURATION)
	tween.set_loops()
