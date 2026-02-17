extends Spell
class_name GeyserSpell

@onready var line_2d: Line2D = $Line2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@onready var hit_box: HitBox = $HitBox

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@onready var state_machine: StateMachine = $StateMachine

@export var range_max: float = 600.0
@export var rotation_speed: float= 100.0
@export var duration: float= 5.0

var target_lenght: float:
	set(value):
		if value != target_lenght:
			target_lenght = value
			_set_line_lenght(target_lenght)
			_set_ray_cast_lenght(target_lenght)

var tween: Tween

func _set_line_lenght(lenght: float) -> void:
	line_2d.points[1].x = lenght / 3
	line_2d.points[2].x = lenght

func _set_ray_cast_lenght(lenght: float) -> void:
	ray_cast_2d.target_position.x = lenght

