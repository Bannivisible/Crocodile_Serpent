extends State
class_name BMC_FreeMoveState

@export var acceleration: float = 0.3

@export var bmc: BMC= owner

func update(_delta: float) -> void:
	var velocity_y: float= lerp(object.velocity.y, bmc.speed.value * bmc.dir.y * BMC_MoveState.MULT_SPEED, acceleration)
	object.velocity.y = velocity_y

func enter() -> void:
	super.enter()
	
	object.velocity.y = 0.0

func exit() -> void:
	super.exit()
	
	while object.velocity.y > BMC_MoveState.MIN_SPEED:
		object.velocity.y = lerp(object.velocity.y, 0.0, acceleration)
	
	object.velocity.y = 0.0
