extends Component
class_name BMC

@export var speed: SpeedStat

@export var facing_node: Node2D
@onready var anim_player: AnimationPlayer= owner.get_node("AnimationPlayer")
@onready var anim_tree: AnimationTree= owner.get_node("AnimationTree")

@onready var state_machine_x: StateMachine = $StateMachineX
@onready var state_machine_y: StateMachine = $StateMachineY

@onready var character: Character= object

var facing_direction := Vector2.RIGHT:
	set(value):
		if value != facing_direction:
			facing_direction = value
			facing_direction_changed.emit(facing_direction)

var dir: Vector2:
	set(value):
		if value != dir:
			dir = value
			dir_changed.emit(dir)

signal dir_changed(dir: Vector2)
signal facing_direction_changed(face_dir: Vector2)

#### BUILT-IN ####
func _ready() -> void:
	Events.cs_interface_on_screen_changed.connect(func(on_screen):
		if on_screen: 
			immobilize()
		else :
			free_immobilize()
			)
	
	facing_direction_changed.connect(_on_face_dir_changed)
	state_machine_x.state_changed_recur.connect(_on_state_machine_state_change_recur)
	state_machine_y.state_changed_recur.connect(_on_state_machine_state_change_recur)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	character.move_and_slide()
	
	if character.is_on_floor() and $StateMachineY/Air/Fall.is_current_state():
		state_machine_y.set_state($StateMachineY/Grounded/Idle)
	
	elif character.velocity.y > 0:
		if $StateMachineY/Grounded.is_current_state() or $StateMachineY/Air/Jump.is_current_state():
			state_machine_y.set_state_with_string("Fall")

func _update_animation() -> void:
	var x_state_name: String= state_machine_x.get_deepest_state().name
	var y_state_name: String= state_machine_y.get_deepest_state().name
	var anim_name: String= x_state_name + "-" + y_state_name
	
	if anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
	elif anim_player.has_animation(y_state_name):
		anim_player.play(y_state_name)
	elif anim_player.has_animation(x_state_name):
		anim_player.play(x_state_name)

#### LOGIC ####
func update_velocity_with_dir() -> void:
	character.velocity = dir * speed.value * BMC_MoveState.MULT_SPEED

func immobilize() -> void:
	state_machine_x.lock_state($StateMachineX/BaseState/Idle)
	state_machine_y.lock_state($StateMachineY/Grounded/Idle)

func free_immobilize() -> void:
	state_machine_x.unlock_state()
	state_machine_y.unlock_state()

#### SIGNAL RESPONSES ####
func _on_dir_changed(_dir: Vector2) -> void:
	# X axis
	if dir.x != 0.0:
		facing_direction.x = sign(dir.x)

func _on_face_dir_changed(_dir: Vector2) -> void:
	if facing_node:
		facing_node.scale.x = facing_direction.x

func _on_state_machine_state_change_recur(_state: State, _deep_state: State) -> void:
	_update_animation()
