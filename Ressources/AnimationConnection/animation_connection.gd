extends Resource
class_name AnimationConnection

@export var from: StringName

@export var to: StringName

@export var to_port: int

func _init(_from: StringName= from, _to: StringName= to, _to_port: int= to_port) -> void:
	from = _from
	to =_to
	to_port = _to_port

func print_connection() -> void:
	print(from + " -> " + "%s]" % to_port + to)
