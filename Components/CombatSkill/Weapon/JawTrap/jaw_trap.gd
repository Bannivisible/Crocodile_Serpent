extends Weapon
class_name JawTrap

#@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
#@onready var animation_tree: AnimationTree = $"../../AnimationTree"
#
#
#func _ready() -> void:
	#pass
#
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("attack"):
		#animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
