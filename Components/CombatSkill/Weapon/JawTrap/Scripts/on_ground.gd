extends StateMachine

@export var gravity: float= 1.0
@export_range(0.0, 1000.0, 1.0) var bring_back_amount: float= 500.0
@export var min_dist: float= 0.0

@onready var jaw_trap: JawTrap = owner
@onready var procedural_link: ProceduralLink = $ProceduralLink
@onready var idle_hand: State = $"../OnHand/Idle"
@onready var innit_max_dist: float= procedural_link.max_dist

var parent: Node

#### BUILT-IN ####

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("special") and is_current_state():
		procedural_link.max_dist -= bring_back_amount * delta
		
		if procedural_link.max_dist <= min_dist:
			get_top_state_machine().set_state(idle_hand)

#### INHERITANCE ####

func enter() -> void:
	super.enter()
	
	_setup_tree()
	
	procedural_link.node_a = jaw_trap.object

#func update(delta: float) -> void:
	#owner.global_position += Vector2.DOWN * gravity * delta

func exit() -> void:
	super.exit()
	
	jaw_trap.get_parent().remove_child(jaw_trap)
	jaw_trap.position = Vector2.ZERO
	jaw_trap.rotation = 0.0
	parent.add_child(jaw_trap)
	
	procedural_link.node_a = null
	procedural_link.max_dist = innit_max_dist

#### LOGIC ####

func _setup_tree() -> void:
	var pos: Vector2= jaw_trap.global_position
	var root: Node= get_tree().root.get_child(0)
	
	parent = jaw_trap.get_parent()
	parent.remove_child(jaw_trap)
	
	root.add_child(jaw_trap)
	
	jaw_trap.global_position = pos
