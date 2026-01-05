extends Node
class_name ProceduralLink

@export var node_a: Node2D
@export var node_b: Node2D

@export_range(0.0, 99999.9) var max_dist: float

func _process(_delta: float) -> void:
	if node_a == null or node_b == null: return
	
	var dist := node_a.global_position.distance_to(node_b.global_position)
	
	if dist > max_dist:
		restrict_position(dist)

func restrict_position(dist: float) -> void:
	var dir := node_b.global_position.direction_to(node_a.global_position)
	var dist_diff: float= dist - max_dist
	
	node_b.global_position += dir * dist_diff
