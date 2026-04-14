extends State


@export_range(1.0, 10.0) var grow_mult_range: float = 3.0

@onready var deflagration: ProjectileDeflagration = owner

const EXPLOSION_SCALE_ANIMATION_DURATION: float = 0.5
const EXPLOSION_ROTATION_ANIMATION_AMOUNT: float = -PI/4

#### INHERITENCE  ####
func enter() -> void:
	_grow_animation()


#### LOGIC ####
func _grow_animation() -> void:
	var tween: Tween= deflagration.tween
	
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(deflagration, "scale", deflagration.scale * grow_mult_range, EXPLOSION_SCALE_ANIMATION_DURATION)
	tween.tween_callback(func(): state_machine.set_state_with_string("Explode"))
