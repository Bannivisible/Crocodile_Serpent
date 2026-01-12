extends Character

@onready var free: BMC_FreeState = $BMC/StateMachineY/Air/Free

@onready var bmc: BMC = $BMC
@onready var state_machine_x: StateMachine = $BMC/StateMachineX
@onready var state_machine_y: StateMachine = $BMC/StateMachineY
@onready var rotate_dir: BMC_RotateDirState = $BMC/StateMachineY/Air/Free/RotateDir


func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("special"):
		#state_machine_x.set_state_with_string("ConstantDash")
		#state_machine_y.set_state($BMC/StateMachineY/Air/Free/RotateDir)
	
	#if Input.is_action_just_pressed("ui_up"):
		#rotate_dir.angle += PI/6
	pass

func set_free_idle() -> void:
	free.set_state_with_string("FreeIdle")
