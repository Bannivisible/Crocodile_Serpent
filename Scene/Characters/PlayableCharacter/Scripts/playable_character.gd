extends Character
class_name PlayableCharacter

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var controler: Controler = $PlayerControler


func immobilize() -> void:
	velocity_component.dir = Vector2.ZERO
	controler.active = false


func free_immobolize() -> void:
	controler.active = true
