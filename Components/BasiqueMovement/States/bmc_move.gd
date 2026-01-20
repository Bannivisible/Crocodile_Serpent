extends State
class_name BMC_MoveState

@export var acceleration: float = 0.3

@onready var bmc: BMC= owner

const MULT_SPEED: float= 10.0
const MIN_SPEED: float= 0.05

func _ready() -> void:
	bmc.dir_changed.connect(_on_bmc_dir_changed)

func update(_delta: float) -> void:
	var velocity_x: float= lerp(bmc.object.velocity.x, bmc.charac_stat.speed * bmc.dir.x * MULT_SPEED, acceleration)
	bmc.object.velocity.x = velocity_x

func exit() -> void:
	super.exit()
	while bmc.object.velocity.x > MIN_SPEED:
		bmc.object.velocity.x = lerp(bmc.object.velocity.x, 0.0, acceleration)
	
	bmc.object.velocity.x = 0.0

func _on_bmc_dir_changed(dir: Vector2) -> void:
	if dir == Vector2.ZERO and is_current_state():
		state_machine.set_state_with_string("Idle")
