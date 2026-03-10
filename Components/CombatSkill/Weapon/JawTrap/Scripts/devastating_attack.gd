extends AttackState


@export var state_machine_path: NodePath= "StateMachine"
@export var state_name: String= "Torpedo"

@export var buff_speed: Buff


@onready var croc_state_machine: StateMachine= get_object_node(state_machine_path)


func enter() -> void:
	super.enter()
	croc_state_machine.set_state_with_string(state_name)


func exit() -> void:
	super.exit()
	croc_state_machine.set_state_with_string("Idle")


