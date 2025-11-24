extends Weapon
class_name JawTrap

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@onready var animation_tree: AnimationTree= $"../../AnimationTree"

@export var animations: AnimationLibrary

@export var node_one_shot: AnimationNodeOneShot

func _ready() -> void:
	animation_player.add_animation_library(&"JawTrap", animations)
	var tree: AnimationNodeBlendTree= animation_tree.tree_root
	tree.add_node(&"jaw_trap_one_shot" ,node_one_shot)
	var anim:= AnimationNodeAnimation.new()
	anim.animation = &"JawTrap/SlashAttack1"
	tree.add_node(&"SlashAttack1", anim)
	tree.connect_node(&"jaw_trap_one_shot", 1, &"SlashAttack1")
	tree.disconnect_node(&"output", 0)
	tree.connect_node(&"jaw_trap_one_shot", 0, &"StateMachine")
	tree.connect_node(&"output", 0, &"jaw_trap_one_shot")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		animation_tree.set("parameters/jaw_trap_one_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		#animation_player.play("JawTrap/SlashAttack1")
