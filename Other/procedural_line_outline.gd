extends Line2D
class_name LineOutline

@export var line: Line2D

func _physics_process(_delta: float) -> void:
	var line_points: Array[Vector2]= []
	for point in line.points:
		line_points.append(to_local(point))
	
	points = line_points
