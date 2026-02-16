extends Node2D
class_name Factory



#### BUILT-IN ####
func _ready() -> void:
	Events.request_spawn_object.connect(_on_Events_request_spawn_object)


#### LOGIC ####
func spawn_object(node: Node2D) -> void:
	add_child(node)


#### SIGNAL RESPONSES ####
func _on_Events_request_spawn_object(node: Node2D) -> void:
	spawn_object(node)
