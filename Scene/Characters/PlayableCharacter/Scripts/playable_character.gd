extends Character
class_name PlayableCharacter

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var controler: Controler = $PlayerControler


#### BUILT-IN ####
func _ready() -> void:
	Events.cs_interface_on_screen_changed.connect(_on_Events_cs_interface_on_screen_changed)


#### LOGIC ####
func immobilize() -> void:
	velocity_component.dir = Vector2.ZERO
	controler.active = false


func free_immobolize() -> void:
	controler.active = true


func _can_play() -> bool:
	return true


#### SIGNALS RESPONSES ####
func _on_Events_cs_interface_on_screen_changed(on_screen: bool) -> void:
	if on_screen: immobilize()
	elif _can_play():  free_immobolize()

