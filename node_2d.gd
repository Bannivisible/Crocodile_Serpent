@tool
extends Node2D

var teamName

@export var aa_bb: Transform2D

func _ready() -> void:
	pass

func _get_property_list() -> Array:
	var properties: Array
	properties.append({
		"name": "teamName",
		"type": TYPE_AABB,
		"usage": PROPERTY_USAGE_DEFAULT, # Simple variables don't need hints
										# or hint_strings
	})
	return properties
