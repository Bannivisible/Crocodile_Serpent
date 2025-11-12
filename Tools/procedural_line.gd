@tool
extends Line2D
class_name ProceduralLine

@onready var distance_radius_array: Array[float]= _get_distance_raidius_array()
@export var radius: float:
	set(value):
		if value != radius:
			radius = value
			_init_points()

@export_range(0.0, 1.0) var initial_distance_ratio: float
@export var initial_direction: Vector2

var test

func _get_property_list() -> Array[Dictionary]:
	var property: Array[Dictionary]= []
	
	property.append({
		"name": "test",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT
		
	})
	
	return property
#
##### BUILT-IN ####
func _process(_delta: float) -> void:
	
	_limit_distance_between_points()
#
#### LOGIC ###
func _init_points() -> void:
	for i in range(len(points)):
		points[i] = initial_direction * radius * initial_distance_ratio * i

func _get_distance_raidius_array() -> Array[float]:
	var res: Array[float]= []
	
	for i in range(len(points) -1):
		var dist: float= points[i].distance_to(points[i+1])
		res.append(dist)
	
	return res

func _limit_distance_between_points() -> void:
	for i in range(1, len(points)):
		points[i] = points[i-1] + (points[i] - points[i-1]).limit_length(radius)
