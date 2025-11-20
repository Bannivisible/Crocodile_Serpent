@tool
extends Node2D

@export var nb_link: int:
	set = _set_nb_link

func _set_nb_link(value: int) -> void:
	nb_link = value
	if not Engine.is_editor_hint(): return
	
	_remove_all_child()
	for i in range(nb_link):
		_add_link(i)

func _remove_all_child() -> void:
	for child in get_children():
		remove_child(child)

@export var front_part: StaticBody2D
@onready var pin_joint_front: PinJoint2D = $"../Front/PinJointFront"

@export var back_part: StaticBody2D
@onready var pin_joint_back: PinJoint2D = $"../Back/PinJointBack"

@export var jaw_trap_texture: Texture

@export var region_link_left: Rect2
@export var region_link_right: Rect2

@export var shape: Shape2D

@export var physics_material: PhysicsMaterial

var pair: bool= false

func _ready() -> void:
	if not Engine.is_editor_hint() and nb_link > 0:
		for i in range(nb_link):
			_add_link(i)
		
		for i in range(nb_link-1):
			_add_joint(i)
		
		pin_joint_front.node_b = NodePath("../../Links/Link1")
		pin_joint_back.node_a = NodePath("../../Links/" + "Link" + str(nb_link))

func _add_link(i: int) -> void:
	var link := RigidBody2D.new()
	_add_collision(link)
	_set_visual(link)
	_set_position(link, i)
	
	link.physics_material_override = physics_material
	
	link.name = "Link" + str(i+1)
	add_child(link)

func _set_visual(link: RigidBody2D) -> void:
	var sprite_left: Sprite2D= _create_sprite_link(true)
	var sprite_right: Sprite2D= _create_sprite_link(false)
	
	link.add_child(sprite_left)
	link.add_child(sprite_right)

func _create_sprite_link(left: bool) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.z_index = -1 if left else 1
	sprite.offset.y = 3.0
	sprite.position.x = -3.0 if left else  3.0
	
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = jaw_trap_texture
	atlas_texture.region = region_link_left if left else region_link_right
	sprite.texture =atlas_texture
	
	sprite.name = "LeftPart" if left else "RightPart"
	return sprite

func _set_position(link: RigidBody2D, i: int) -> void:
	link.position.x = 20.0 * float(i)
	link.rotation = PI/2

func _add_collision(link: RigidBody2D) -> void:
	var collision := CollisionShape2D.new()
	collision.shape = shape
	
	link.set_collision_layer_value(1, false)
	link.set_collision_mask_value(1, false)
	
	link.add_child(collision)

func _add_joint(i: int) -> void:
	if nb_link < 2: return
	
	var joint := PinJoint2D.new()
	joint.position.x = 10.0
	
	joint.name = "Joint" + str(i+1) + "_" + str(i+2)
	
	joint.node_a = "../"
	joint.node_b = "../../" + _get_link(i+2).name
	_get_link(i+1).add_child(joint)

func _get_link(i: int) -> RigidBody2D:
	return get_node("Link" + str(i))
