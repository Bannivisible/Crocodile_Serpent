extends Node
class_name ScaleXFaceInverser

@export var active: bool= true

@export var facing_nodes: Array[Node2D]

@onready var vel_comp: VelocityComponent= owner


func _ready() -> void:
	vel_comp.face_dir_changed.connect(_on_vel_comp_face_dir_changed)


func _on_vel_comp_face_dir_changed(dir: Vector2) -> void:
	if not active: return
	for node in facing_nodes:
		node.scale.x = abs(node.scale.x) * dir.x
