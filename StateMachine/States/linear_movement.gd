extends State
class_name LinearMovement

@export var direction := Vector2.RIGHT

@export var distance: float= 100.0
@export var speed: float= 1.0
@export var ease_type: Tween.EaseType
@export var transition_type: Tween.TransitionType

var tween: Tween

signal destination_reached

func enter() -> void:
	
	if tween: tween.kill()
	tween = create_tween().set_ease(ease_type).set_trans(transition_type)
	tween.tween_property(owner, "global_position", owner.global_position + distance * direction, 1/speed)
	tween.tween_callback(func(): destination_reached.emit())

func exit() -> void:
	tween.kill()
