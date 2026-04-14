extends State

@onready var deflagration: ProjectileDeflagration = owner
@onready var timer: Timer = $Timer

@export_range(1.0, 10.0) var explosion_mult_range: float = 3.0

@export var damage_interval: float= 1.0

const EXPLOSION_SCALE_ANIMATION_DURATION: float = 0.5
const EXPLOSION_ROTATION_ANIMATION_AMOUNT: float = -PI/4


func enter() -> void:
	timer.start()
	
	deflagration.damage_inteval = damage_interval
	_grow_animation()

func update(delta: float) -> void:
	deflagration.sprite_2d.rotation += PI/2 * delta


func _grow_animation() -> void:
	var tween: Tween= deflagration.tween
	
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(deflagration, "scale", deflagration.scale * explosion_mult_range, EXPLOSION_SCALE_ANIMATION_DURATION)
	tween.tween_callback(func(): state_machine.set_state_with_string("Explode"))



func _on_timer_timeout() -> void:
	state_machine.set_state_with_string("Disapear")
