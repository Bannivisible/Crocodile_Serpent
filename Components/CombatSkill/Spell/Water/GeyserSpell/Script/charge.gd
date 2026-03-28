extends State

@onready var spell: GeyserSpell = owner
@onready var animation_state_machine: StateMachine = $"../../AnimationStateMachine"


func enter() -> void:
	spell.gpu_particles_2d.emitting = true
	
	animation_state_machine.set_state_with_string("Charge")

func exit() -> void:
	spell.line_2d.visible = true
	spell.ray_cast_2d.enabled = true
	
	spell.gpu_particles_2d.emitting = false
