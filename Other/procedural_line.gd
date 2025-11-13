extends Node2D
class_name ProceduralLine

var line: Line2D

@export var size: int

@export var distance: float
@export var velocity: float

@export var init_dir:= Vector2.RIGHT

##### BUILT-IN ####
func _ready() -> void:
	_init_line()

func _physics_process(delta: float) -> void:
	_limit_distance_between_points(delta)

#### LOGIC ###
func _init_line() -> void:
	if line: line.queue_free()
	line = Line2D.new()
	
	_init_points()
	
	Utiles.add_child_to_root(self, line)

func _init_points() -> void:
	for i in range(size):
		line.points.append(init_dir * distance * i)

func _limit_distance_between_points(delta: float) -> void:
	print(line.points)
	
	for i in range(1, len(line.points)):
		var current_point: Vector2= line.points[i]
		var previous_point: Vector2= line.points[i-1]
		
		var dir: Vector2= current_point - previous_point
		var dist: float= dir.length()
		var dist_limiter: float= max(dist - distance, 0.0)
		
		if dist != 0:
			dir = dir.normalized()
			current_point += (dir - Vector2.ONE*dist_limiter) * velocity * delta
