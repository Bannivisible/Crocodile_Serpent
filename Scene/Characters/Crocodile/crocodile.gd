extends Character
class_name Crocodile


@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var controler: Controler = $Controler


func _input(_event: InputEvent) -> void:
	pass


func immobilize() -> void:
	velocity_component.dir = Vector2.ZERO
	controler.active = false


func free_immobolize() -> void:
	controler.active = true
