extends Character

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"):
		animation_player.play("Charge")
