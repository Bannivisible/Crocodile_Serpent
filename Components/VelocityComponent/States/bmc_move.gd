extends State
class_name VelocityComponent_MoveState

@export var acceleration: float = 0.3

@onready var vel_cpnt: VelocityComponent= owner


func _ready() -> void:
	vel_cpnt.dir_changed.connect(_on_VelocityComponent_dir_changed)

func update(_delta: float) -> void:
	var velocity_x: float= lerp(vel_cpnt.object.velocity.x, vel_cpnt.charac_stat.speed * vel_cpnt.dir.x * VelocityComponent.MULT_SPEED, acceleration)
	vel_cpnt.object.velocity.x = velocity_x

func exit() -> void:
	super.exit()
	while vel_cpnt.object.velocity.x > VelocityComponent.MIN_SPEED:
		vel_cpnt.object.velocity.x = lerp(vel_cpnt.object.velocity.x, 0.0, acceleration)
	
	vel_cpnt.object.velocity.x = 0.0

func _on_VelocityComponent_dir_changed(dir: Vector2) -> void:
	if dir == Vector2.ZERO and is_current_state():
		state_machine.set_state_with_string("Idle")
