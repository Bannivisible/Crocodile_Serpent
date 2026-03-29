extends Controler

@export var cursor_speed: float= 200.0
@export var stal_rot_speed: float= PI


@onready var stal_blizz_spell: StalactiteBlizzard = owner
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var timer: Timer = $"../Timer"


#### BUILT-IN ####
func _physics_process(delta: float) -> void:
	if stal_blizz_spell.current_stalactite == null: return
	
	if state_machine.get_state_name() == "PlaceStalactite":
		_place_stalactite(delta)
	elif state_machine.get_state_name() == "RotateStalactite":
		_rotate_stalactite(delta)


func _input(_event: InputEvent) -> void:
	var state: String= state_machine.get_state_name()
	
	if Input.is_action_just_pressed("attack"):
		if state == "Idle":
			state_machine.set_state_with_string("SpawnProjectileState")
			
			if timer.is_stopped(): timer.start()
		
		elif state == "PlaceStalactite" and _can_place_stalactite():
			state_machine.set_state_with_string("RotateStalactite")
		
		elif state == "RotateStalactite" and _can_place_stalactite():
			state_machine.set_state_with_string("Idle")
	
	if state == "RotateStalactite":
		_change_rote_dir()


#### LOGIC ####
func _place_stalactite(delta: float) -> void:
	var dir: Vector2= Input.get_vector("left", "right", "up", "down")
	dir = dir * cursor_speed * delta
	
	var stalactite: Stalactite= stal_blizz_spell.current_stalactite
	stalactite.global_position += dir


func _rotate_stalactite(delta: float) -> void:
	var stalactite: Stalactite= stal_blizz_spell.current_stalactite
	stalactite.rotation += stal_rot_speed * delta


func _change_rote_dir() -> void:
	for actions in [["left", "right"], ["up", "down"]]:
		var axis: float= Input.get_axis(actions[0], actions[1])
		
		if axis != 0.0:
			stal_rot_speed = abs(stal_rot_speed) * axis


func _can_place_stalactite() -> bool:
	return stal_blizz_spell.current_stal_pos_valide()

