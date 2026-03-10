extends State


@onready var stal_blizz_spell: StalactiteBlizzard = $"../.."


func exit() -> void:
	stal_blizz_spell.free_player()
