extends Ennemy


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("attack"):
		#var pos: Vector2= global_position + Vector2(100.0, -50.0)
		#$VelocityComponent.tween_pos_to(pos, 1.0)

func _ready() -> void:
	pass

#func _process(delta: float) -> void:
	#print($VelocityComponent/StateMachineX/BaseState.current_state)
