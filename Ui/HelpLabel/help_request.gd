extends Node
class_name HelpRequest


@export_multiline() var text: String


func _enter_tree() -> void:
	Events.request_help.emit(text)
