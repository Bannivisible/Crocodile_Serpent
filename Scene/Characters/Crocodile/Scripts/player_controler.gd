extends Controler

@onready var state_machine: StateMachine = $"../StateMachine"

@onready var velocity_component: VelocityComponent = $"../VelocityComponent"
@onready var jump_state: Node = $"../StateMachine/Jump"
@onready var fall_state: Node = $"../StateMachine/Fall"
@onready var bent_down_state: StateMachine = $"../StateMachine/BentDown"


func _ready() -> void:
	Events.cs_interface_on_screen_changed.connect(_on_Events_cs_interface_on_screen_changed)


func _input(_event: InputEvent) -> void:
	velocity_component.dir.x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		state_machine.set_state_with_string("Jump")
	
	elif Input.is_action_just_released("jump") and jump_state.is_current_state():
		owner.velocity.y = - jump_state.force / fall_state.jump_mitigation
		state_machine.set_state_with_string("Fall")
	
	
	elif Input.is_action_just_pressed("bent_down") and owner.is_on_floor():
		state_machine.set_state_with_string("BentDownIdle")
	
	if Input.is_action_just_released("bent_down") and bent_down_state.is_current_state():
		state_machine.set_state_with_string("Idle")


func _on_Events_cs_interface_on_screen_changed(on_screen: bool) -> void:
	velocity_component.dir = Vector2.ZERO
	active = !on_screen
