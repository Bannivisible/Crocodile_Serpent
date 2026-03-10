extends State


@export_range(0.0, 1.0, 0.01) var stal_alpha: float= 0.5

@onready var stal_blizz_spell: StalactiteBlizzard = owner


func enter() -> void:
	stal_blizz_spell.immobilize_player()
	
	stal_blizz_spell.current_stalactite.modulate.a = stal_alpha


func exit() -> void:
	stal_blizz_spell.current_stalactite.modulate.a = 1.0
