extends Ennemy

@onready var charge: VelocityComponent_ChargeState = $VelocityComponent/StateMachineX/BaseState/Charge
@onready var idle: VelocityComponent_IdleState = $VelocityComponent/StateMachineX/BaseState/Idle

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("attack"):
		#var pos: Vector2= global_position + Vector2(100.0, -50.0)
		#$VelocityComponent.tween_pos_to(pos, 1.0)

func _ready() -> void:
	idle.state_entered.connect(func():
		"")
	
	
	
	
	var player: Character= get_tree().get_first_node_in_group(Game.player_group_name)
	charge.target_pos = player.global_position
	$VelocityComponent/StateMachineX.set_state($VelocityComponent/StateMachineX/BaseState/Charge)


#func _process(delta: float) -> void:
	#print($VelocityComponent/StateMachineX/BaseState.current_state)
