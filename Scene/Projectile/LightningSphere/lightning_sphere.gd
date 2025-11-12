extends Projectile
class_name LightningSphere

@export var rotation_speed: float= 1.0

@onready var timer: Timer = $Timer

var is_activate: bool= true

signal disapear(sphere)

func _physics_process(delta: float) -> void:
	_rotate_forever(delta)

func _rotate_forever(delta: float):
	if !is_activate: return
	rotation += delta * rotation_speed

func activate() -> void:
	is_activate = true
	timer.start()

func desactivate() -> void:
	is_activate = false


func _on_timer_timeout() -> void:
	disapear.emit(self)
	factory.desactivate_instance(self)
