extends State


func enter() -> void:
	owner.free_player()


func exit() -> void:
	owner.immobilize_player()
