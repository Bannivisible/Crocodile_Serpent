extends Node2D

@export var nb_link: int:
	set = _set_nb_link

func _set_nb_link(value: int) -> void:
	var prev_nb: int= nb_link
	nb_link = value
	if nb_link < prev_nb:
		for i in range(nb_link, prev_nb):
			remove_child(_get_link(i))
			var joint: Node= get_child(get_child_count()-1)
			if joint is PinJoint2D: remove_child(joint)
	else :
		for i in range(prev_nb ,nb_link):
			_add_link(i)

@export var front_part: StaticBody2D
@export var back_part: StaticBody2D

@export var jaw_trap_texture: Texture

@export var region_link_left: Rect2
@export var region_link_right: Rect2

@export var shape: Shape2D

var pair: bool= false

func _add_link(i: int) -> void:
	var link := RigidBody2D.new()
	_set_visual(link)
	_set_position(link, i)
	
	link.name = "Link" + str(i)
	add_child(link)
	_add_joint(link, i)
	print(get_children())

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
	
	sprite.name = "LeftPart" if left else "RightPart"
	return sprite

func _set_position(link: RigidBody2D, i: int) -> void:
	link.position.x = 20.0 * float(i)

func _add_collision(link: RigidBody2D) -> void:
	var collision := CollisionShape2D.new()
	collision.shape = shape
	
	link.set_collision_layer_value(1, false)
	link.set_collision_mask_value(1, false)
	
	link.add_child(collision)

func _add_joint(link: RigidBody2D, i: int) -> void:
	if nb_link < 2: return
	
	var joint := PinJoint2D.new()
	joint.position.x = 10.0 * float(i)
	
	add_child(joint)
	joint.node_a = _get_link(i-1).get_path()
	joint.node_a = link.get_path()

func _get_link(i: int) -> RigidBody2D:
	@warning_ignore("integer_division")
	return get_child(i/2 -1)
	
