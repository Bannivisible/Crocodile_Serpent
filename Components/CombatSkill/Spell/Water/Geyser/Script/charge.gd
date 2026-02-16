extends State

@onready var spell: GeyserSpell = owner

func enter() -> void:
	spell.gpu_particles_2d.emitting = true

func exit() -> void:
	spell.line_2d.visible = true
	spell.ray_cast_2d.enabled = true
	
	spell.gpu_particles_2d.emitting = false
