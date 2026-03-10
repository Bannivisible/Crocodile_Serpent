extends State


@onready var spell: GeyserSpell= owner


func enter() -> void:
	if not owner.is_node_ready(): await owner.ready
	
	spell.line_2d.visible = false
	spell.ray_cast_2d.enabled = false
	spell.rotation = 0.0
	
	spell.free_player()


func exit() -> void:
	spell.immobilize_player()

