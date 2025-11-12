extends Projectile
class_name ProjectileFireBall

var origine_scale : Vector2= scale

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine

var tween: Tween
const APPEARING_TWEEN_DURATION: float = 0.25
const DISAPPEARING_TWEEN_DURATION: float = 0.25

func _ready() -> void:
	super._ready()
	
	$StateMachine/LinearMovement.destination_reached.connect(_on_LinearMovement_destination_reached)
	scale = Vector2.ZERO
	activate()

func activate() -> void:
	state_machine.set_state_with_string("Appear")

func desactivate() -> void:
	state_machine.set_state_with_string("Desactivate")

#### SIGNAL RESPONSES ####
func _on_area_2d_entered(area: Area2D) -> void:
	super._on_area_2d_entered(area)
	if area.owner.faction != faction:
		state_machine.set_state_with_string("Disapear")

func _on_LinearMovement_destination_reached() -> void:
	state_machine.set_state_with_string("Disapear")
