extends WeaponAttackState

@onready var front: StaticBody2D = $"../../../Front"
@onready var throw_attack: Node = $"../ThrowAttack"

var remote_hand: RemoteTransform2D
var remote_path: NodePath= "../../../../../../../../../CSManager/JawTrap/Front"

func _ready() -> void:
	await super._ready()
	
	var throw_anime: Animation= animation_manager.get_animation(throw_attack.anim_name)
	combo_cooldown += throw_anime.length + throw_attack.time 
	$"../ThrowIntermediate".wait_time = throw_attack.time + combo_cooldown
	
	combo_timer = _create_combo_timer()
	
	remote_hand = object.get_node("Skeleton2D/Center/Body/Torso/ArmFront/ForeArmFront/HandFront/HandFrontTarget/HandFrontTarget")

func recall() -> void:
	var tween := create_tween()
	tween.set_ease(throw_attack.tw_ease).set_trans(throw_attack.tw_trans)
	tween.tween_property(front, "global_position", remote_hand.global_position, throw_attack.time)
	tween.tween_callback(func(): remote_hand.remote_path = remote_path)
	
	var hit_box_tween := create_tween()
	var collision_shape: CollisionShape2D= hit_box.get_child(0)
	hit_box_tween.set_ease(throw_attack.tw_ease).set_trans(throw_attack.tw_trans)
	hit_box_tween.tween_property(collision_shape, "global_position", remote_hand.global_position, throw_attack.time)

func enter() -> void:
	super.enter()
	recall()
