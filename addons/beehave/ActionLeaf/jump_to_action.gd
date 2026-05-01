@tool
extends ActionLeaf

@export var jump_state: JumpState
@export var vel_comp: VelocityComponent 
@export var to_pos: Vector2
@export var height: float

var prev_jump_force: float

#### BUILT-IN ####
func _ready() -> void:
	jump_state.state_exited.connect(_on_jump_state_exited)


func _physics_process(_delta: float) -> void:
	pass


#### INHERITENCE ####
func tick(actor: Node, blackboard: Blackboard) -> int:
	_setup_path_manager()
	_setup_jump_state(actor)
	
	return SUCCESS


#### LOGIC ####
func _setup_path_manager() -> void:
	var path_manager := vel_comp.path_manager
	path_manager.add_target_at_begining(to_pos)
	path_manager.active = true


func _setup_jump_state(actor: Character) -> void:
	prev_jump_force = jump_state.force
	
	jump_state.state_machine.current_state = jump_state


func _get_air_time() -> float:
	var jump_time := jump_state.get_air_time()
	
	var fall_state: FallState= jump_state.state_machine.get_node(
		jump_state.fall_state_name)
	var fall_time := to_pos.y / (vel_comp.gravity + fall_state.increase_gravity)
	
	return jump_time + fall_time


func compute_jump_force(character: Character) -> Vector2:
	var dy = to_pos.y - character.global_position.y

	# vitesse verticale initiale
	var vy = -sqrt(2 * vel_comp.gravity * height)

	# temps montée
	var t_up = -vy / vel_comp.gravity

	# hauteur à redescendre
	var h_down = height - dy

	# temps descente
	var t_down = sqrt(2 * h_down / vel_comp.gravity)

	var t = t_up + t_down

	# vitesse horizontale
	var vx = (to_pos.x - character.global_position.x) / t

	return Vector2(vx, vy)


#### SIGNAL RESPONSES ####
func _on_jump_state_exited() -> void:
	jump_state.force = prev_jump_force
