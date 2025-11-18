@tool
extends Node2D

@export var texture: Texture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_child_count())
	var sp:= Sprite2D.new()
	sp.texture = texture
	add_child(sp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
