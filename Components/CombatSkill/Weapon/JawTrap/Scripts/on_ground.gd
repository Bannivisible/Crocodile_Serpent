extends StateMachine

@export var gravity: float
@export_range(0.0, 1000.0, 1.0) var bring_back_amount: float= 500.0

@onready var jaw_trap: JawTrap = owner
@onready var procedural_link: ProceduralLink = $ProceduralLink
@onready var idle_hand: State = $"../OnHand/Idle"
@onready var innit_max_dist: float= procedural_link.max_dist

#### BUILT-IN ####

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("special") and is_current_state():
		procedural_link.max_dist -= bring_back_amount * delta
		
		if procedural_link.max_dist <= bring_back_amount * delta:
			get_top_state_machine().set_state(idle_hand)

#### INHERITANCE ####

func enter() -> void:
	super.enter()
	
	procedural_link.node_a = jaw_trap.object

func update(delta: float) -> void:
	owner.global_position += Vector2.DOWN * gravity * delta

func exit() -> void:
	super.exit()
	
	jaw_trap.position = Vector2.ZERO
	jaw_trap.rotation = 0.0
	jaw_trap.set_as_top_level(false)
	
	procedural_link.node_a = null
	procedural_link.max_dist = innit_max_dist

#### LOGIC ####
