extends Controler


@export var add_radius_amount: float= 150.0

@onready var spiral_spell: SpiralSpell = owner
@onready var state_machine: StateMachine = $"../StateMachine"

@onready var min_radius: float= spiral_spell.spiral_radius


func _physics_process(delta: float) -> void:
	if not active: return
	
	if Input.is_action_just_pressed("attack"):
		spiral_spell.immobilize_player()
	elif Input.is_action_just_released("attack"):
		spiral_spell.free_player()
	
	if Input.is_action_pressed("attack"):
		var coef: float= Input.get_axis("left", "right")
		
		var add_radius: float= add_radius_amount * coef * delta
		spiral_spell.spiral_radius = max(min_radius, spiral_spell.spiral_radius + add_radius)


func _input(_event: InputEvent) -> void:
	var coef: float= Input.get_axis("down", "up")
	
	spiral_spell.nb_wind_sphere += 1 * int(coef)
