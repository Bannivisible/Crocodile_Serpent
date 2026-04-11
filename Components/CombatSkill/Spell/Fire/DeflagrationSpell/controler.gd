extends Controler

@onready var deflagration: DeflagrationSpell = owner

@onready var state_machine: StateMachine = $"../StateMachine"
@onready var spawn_projectile_state: SpawnProjectileState = $"../StateMachine/Charge"


var current_spell: ProjectileDeflagration

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and _can_spawn_projectile():
		state_machine.set_state_with_string("Charge")
	
	elif Input.is_action_just_released("attack") and deflagration.can_cast_projectile():
		var aim: float= _get_aim()
		deflagration.current_projectile.rotation = aim
		state_machine.set_state_with_string("Cast2")



func _get_aim() -> float:
	var joy_axis :float= Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	if joy_axis != 0.0: return joy_axis
	
	var x := Input.get_axis("left", "right")
	var y := Input.get_axis("up", "down")
	var dir := Vector2(x, y)
	
	return dir.angle()


func _can_spawn_projectile() -> bool:
	return deflagration.current_projectile == null
