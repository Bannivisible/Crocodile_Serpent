extends Node

@onready var vel_comp: VelocityComponent= owner

@export var facing_nodes: Array[Node2D]

func _ready() -> void:
	vel_comp.facing_direction_changed.connect(_on_vel_comp_facing_direction_changed)


func _on_vel_comp_facing_direction_changed(dir: Vector2) -> void:
	for node in facing_nodes:
		node.scale.x = abs(node.scale.x) * dir.x
