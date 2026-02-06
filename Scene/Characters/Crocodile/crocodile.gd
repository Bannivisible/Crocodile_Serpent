extends Character

@onready var free: VelocityComponent_FreeState = $VelocityComponent/StateMachineY/Air/Free

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var state_machine_x: StateMachine = $VelocityComponent/StateMachineX
@onready var state_machine_y: StateMachine = $VelocityComponent/StateMachineY
@onready var rotate_dir: VelocityComponent_RotateDirState = $VelocityComponent/StateMachineY/Air/Free/RotateDir


func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("special"):
		#state_machine_x.set_state_with_string("ConstantDash")
		#state_machine_y.set_state($VelocityComponent/StateMachineY/Air/Free/RotateDir)
	
	#if Input.is_action_just_pressed("ui_up"):
		#rotate_dir.angle += PI/6
	pass

func set_free_idle() -> void:
	free.set_state_with_string("FreeIdle")
