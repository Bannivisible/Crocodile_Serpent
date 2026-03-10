extends Node
class_name RotationLeader

@export var actve: bool= true

@export var nodes: Array[Node2D]

@onready var vel_comp: VelocityComponent= owner


func _ready() -> void:
	vel_comp.dir_changed.connect(_on_vel_comp_dir_changed)


func _on_vel_comp_dir_changed(dir: Vector2) -> void:
	if not actve: return
	for node in nodes:
		node.rotation = dir.angle()
