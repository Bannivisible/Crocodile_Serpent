extends State
class_name VelocityComponent_ChargeState

@export var target_pos: Vector2

const MIN_DIST: float= 10.0

@onready var vel_component: VelocityComponent= owner

var is_dest_reached: bool= false

signal destination_reached(pos: Vector2)

func enter() -> void:
	var charc_pos: Vector2= vel_component.character.global_position
	var dir: Vector2= charc_pos.direction_to(target_pos)
	vel_component.dir = dir


func update(_delta: float) -> void:
	var charc_pos: Vector2= vel_component.character.global_position
	
	if charc_pos.distance_to(target_pos) <= MIN_DIST and not is_dest_reached:
		destination_reached.emit(target_pos)
		
		vel_component.dir = Vector2.ZERO
