extends State
class_name VelocityComponent_FreeMoveState

@export var acceleration: float = 0.3

@export var velocity_component: VelocityComponent= owner

func update(_delta: float) -> void:
	var velocity_y: float= lerp(object.velocity.y, velocity_component.speed.value * velocity_component.dir.y * VelocityComponent.MULT_SPEED, acceleration)
	object.velocity.y = velocity_y

func enter() -> void:
	super.enter()
	
	object.velocity.y = 0.0

func exit() -> void:
	super.exit()
	
	while object.velocity.y > VelocityComponent.MIN_SPEED:
		object.velocity.y = lerp(object.velocity.y, 0.0, acceleration)
	
	object.velocity.y = 0.0
