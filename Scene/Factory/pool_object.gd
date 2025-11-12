extends Node
class_name PoolObject

@export var object_scene: PackedScene

@export_range(0, 999) var pool_size: int = 1

var pool: Array[Node]
var actives: Array[Node]
