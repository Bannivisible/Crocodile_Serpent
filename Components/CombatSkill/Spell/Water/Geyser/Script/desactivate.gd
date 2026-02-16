extends State


@onready var spell: GeyserSpell= owner


func enter() -> void:
	if not owner.is_node_ready(): await owner.ready
	
	spell.line_2d.visible = false
	spell.ray_cast_2d.enabled = false
	spell.rotation = 0.0
	
	_free_player()


func exit() -> void:
	_immobilize_player()


func _immobilize_player() -> void:
	if object is Crocodile:
		object.immobilize()


func _free_player() -> void:
	if object is Crocodile:
		object.free_immobolize()


