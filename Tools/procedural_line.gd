extends Line2D

@export var distance: float
@export var velocity: float

@export var init_dir:= Vector2.RIGHT

#func _get_property_list() -> Array[Dictionary]:
	#var property: Array[Dictionary]= []
	#
	#property.append({
		#"name": "test",
		#"type": TYPE_INT,
		#"usage": PROPERTY_USAGE_DEFAULT
		#
	#})
	##
	##return property
#
###### BUILT-IN ####
#func _ready() -> void:
	#_init_points()
	#get_parent().remove_child(self)
	#get_tree().root.add_child(self)
#
#func _physics_process(delta: float) -> void:
	#_limit_distance_between_points(delta)
#
##### LOGIC ###
#func _init_points() -> void:
	#for i in range(len(points)):
		#points[i] = init_dir * distance * i
#
##func _limit_distance_between_points() -> void:
	##for i in range(1, len(points)):
		##points[i] = points[i-1] + (points[i] - points[i-1]).limit_length(distance)
#
#func _limit_distance_between_points(delta: float) -> void:
	#for i in range(1, len(points)):
		#var current_point: Vector2= points[i]
		#var previous_point: Vector2= points[i-1]
		#
		#var dir: Vector2= current_point - previous_point
		#var dist: float= dir.length()
		#var dist_limiter: float= max(dist - distance, 0.0)
		#
		#if dist != 0:
			#dir = dir.normalized()
			#current_point += (dir - Vector2.ONE*dist_limiter) * velocity * delta
