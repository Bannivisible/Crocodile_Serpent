extends State

@onready var super_fb: ProjectileSuperFireBall = owner

@export_range(1.0, 10.0) var explosion_mult_range: float = 3.0

const EXPLOSION_SCALE_ANIMATION_DURATION: float = 0.5
const EXPLOSION_ROTATION_ANIMATION_AMOUNT: float = -PI/4

func enter() -> void:
	_explode()

func _explode() -> void:
	_explosed_animation()

func _explosed_animation() -> void:
	var tween: Tween= super_fb.tween
	
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(super_fb, "scale", super_fb.scale * explosion_mult_range, EXPLOSION_SCALE_ANIMATION_DURATION)
	
	var rot_tween = tween.parallel().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	rot_tween.tween_property(super_fb.sprite_2d, "rotation", EXPLOSION_ROTATION_ANIMATION_AMOUNT, super_fb.ROTATION_ANIMATION_DURATION)
	
	rot_tween.tween_callback(func(): 
		state_machine.set_state_with_string("Disapear"))
