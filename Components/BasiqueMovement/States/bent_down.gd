extends State
class_name BentDownState

func enter() -> void:
	var collision_shape = object.collision_shape_2d
	collision_shape.position.y += collision_shape.shape.height / 2 - collision_shape.shape.radius
	collision_shape.rotate(PI/2)

func exit() -> void:
	var collision_shape = object.collision_shape_2d
	collision_shape.position.y -= collision_shape.shape.height / 2 - collision_shape.shape.radius
	collision_shape.rotate(PI/2)
