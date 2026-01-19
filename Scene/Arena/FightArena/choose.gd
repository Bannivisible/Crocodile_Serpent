extends State

@onready var fight_arena: FightArena= object


func enter() -> void:
	fight_arena.cs_interface.display()
