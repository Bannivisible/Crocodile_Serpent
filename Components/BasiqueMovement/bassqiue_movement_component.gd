extends Component
class_name BMC

@export var speed: SpeedStat

@export var visual_node: NodePath= "../SpriteContainer"
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

signal dir_changed(dir)
signal facing_direction_changed(face_dir)

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
	
	if character.is_on_floor():
		state_machine_y.set_state_with_string("Grounded")
	
	elif character.velocity.y > 0:
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
func immobilize() -> void:
	state_machine_x.lock_state($StateMachineX/Idle)
	state_machine_y.lock_state($StateMachineY/Grounded)

func free_immobilize() -> void:
	state_machine_x.unlock_state()
	state_machine_y.unlock_state()

#### SIGNAL RESPONSES ####
func _on_dir_changed(_dir: Vector2) -> void:
	# X axis
	if abs(dir.x) != 1.0:
		state_machine_x.set_state_with_string("Idle")
	else:
		state_machine_x.set_state_with_string("Move")
		facing_direction.x = dir.x

func _on_face_dir_changed(_dir: Vector2) -> void:
	pass
	#var visual: Node2D = get_node(visual_node)
	#visual.scale.x = facing_direction.x

func _on_state_machine_state_change_recur(_state: State, _deep_state: State) -> void:
	_update_animation()
