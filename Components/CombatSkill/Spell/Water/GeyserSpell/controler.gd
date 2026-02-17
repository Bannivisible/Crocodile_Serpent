extends Controler


@export var required_time: float= 2.0
@export var min_charge: float


@onready var state_machine: StateMachine = $"../StateMachine"
@onready var cast: Node = $"../StateMachine/Cast"


var charge_rate: float= 0.0


#### BUILT-IN ####
func _physics_process(delta: float) -> void:
	if not active and not state_machine.get_state_name() == "Charge":
		return
	
	if Input.is_action_pressed("attack"):
		charge_rate = clamp(charge_rate  + delta / required_time, 0.0, 1.0)
	
	_roated_geyser(delta)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and _can_charge():
		state_machine.set_state_with_string("Charge")
	
	if Input.is_action_just_released("attack") and _can_cast():
		cast.ratio = charge_rate
		charge_rate = 0.0
		
		state_machine.set_state_with_string("Cast")


#### LOGIC ####
func _roated_geyser(delta: float) -> void:
	if not _can_rotate_geyser(): return
	
	var aim_dir: Vector2= Input.get_vector("left", "right", "up", "down")
	var angle: float= aim_dir.angle()
	
	var rot: float= lerp(owner.rotation, owner.rotation + angle, delta)
	owner.rotation = clamp(rot, -abs(angle), abs(angle))


func _can_rotate_geyser() -> bool:
	if state_machine.get_state_name() == "Desactivate":
		return false
	
	for action in ["left", "right", "up", "down"]:
		if Input.is_action_pressed(action): return true
	
	return false


func _can_charge() -> bool:
	return state_machine.get_state_name() == "Desactivate"


func _can_cast() -> bool:
	var a: bool= state_machine.get_state_name() == "Charge"
	var b: bool= charge_rate >= min_charge
	
	return a and b


