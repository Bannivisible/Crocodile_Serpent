extends State

func enter() -> void:
	var spell: SpellGeyser = owner
	
	#spell._immobilize_if_bmc()
	spell.gpu_particles_2d.emitting = true

func exit() -> void:
	var spell: SpellGeyser = owner
	
	spell.line_2d.visible = true
	spell.ray_cast_2d.enabled = true
	
	spell.gpu_particles_2d.emitting = false
