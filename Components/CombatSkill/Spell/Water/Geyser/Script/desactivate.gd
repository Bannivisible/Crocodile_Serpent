extends State

func enter() -> void:
	var spell: SpellGeyser= owner
	
	spell.line_2d.visible = false
	spell.ray_cast_2d.enabled = false
	spell.rotation = 0.0
	
	#spell._free_immobilize_bmc()
