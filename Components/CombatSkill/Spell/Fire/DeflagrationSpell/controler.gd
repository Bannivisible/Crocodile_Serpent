extends Controler

@onready var deflagration: DeflagrationSpell = owner

@onready var state_machine: StateMachine = $"../StateMachine"
@onready var spawn_projectile_state: SpawnProjectileState = $"../StateMachine/SpawnProjectileState"
@onready var cooldown: Timer = $"../Cooldown"


var current_spell: ProjectileDeflagration

func _input(_event: InputEvent) -> void:
	var aim: float= Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	spawn_projectile_state.rot = aim
	
	if Input.is_action_just_pressed("attack") and _can_spawn_projectile():
		state_machine.set_state_with_string("SpawnProjectileState")
	
	elif Input.is_action_just_released("attack") and cooldown.is_stopped():
		state_machine.set_state_with_string("Idle")
		cooldown.start()
		
		_cast_projectile()


func _can_spawn_projectile() -> bool:
	return deflagration.current_projectile == null and cooldown.is_stopped()


func _cast_projectile() -> void:
	var projectile := deflagration.current_projectile
	
	if projectile:
		projectile.cast()
