extends Character
class_name Ennemy

const MODE_OFFENSIVE_NAME: String= "Offensive"
const MODE_DEFENSIVE_NAME: String= "Defensive"

@onready var mode: StateMachine = $Mode
