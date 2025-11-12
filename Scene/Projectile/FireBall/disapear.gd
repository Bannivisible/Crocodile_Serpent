extends State

@onready var fire_ball: ProjectileFireBall = owner

func enter() -> void:
	var tween: Tween= fire_ball.tween
	
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(fire_ball, "scale", Vector2.ZERO, fire_ball.DISAPPEARING_TWEEN_DURATION)
	
	tween.tween_callback(func(): 
		if fire_ball.factory:
			fire_ball.factory.desactivate_instance(fire_ball)
		)
