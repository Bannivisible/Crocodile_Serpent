extends CharacterBody2D
class_name Character

const MODE_OFFENSIVE_NAME: String= "Offensive"
const MODE_DEFENSIVE_NAME: String= "Defensive"

@onready var mode: StateMachine = $Mode

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_container: Node2D = $SpriteContainer

