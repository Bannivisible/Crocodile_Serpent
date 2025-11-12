extends State

@onready var fire_ball: ProjectileFireBall = owner

func enter() -> void:
	var tween: Tween = fire_ball.tween
	
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(fire_ball, "scale", fire_ball.origine_scale, fire_ball.APPEARING_TWEEN_DURATION)
	
	tween.tween_callback(func():fire_ball.state_machine.set_state_with_string("LinearMovement"))
