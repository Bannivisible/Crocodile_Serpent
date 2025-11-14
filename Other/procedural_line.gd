extends Line2D


@export var anchor_path: NodePath= ".."
@onready var anchor: Node2D= get_node(anchor_path)

@export var distance: float
@export var velocity: float

@export var init_dir:= Vector2.RIGHT

##### BUILT-IN ####
func _ready() -> void:
	_init_points()
	
	Utiles.add_child_to_root(self)

func _physics_process(delta: float) -> void:
	_limit_distance_between_points(delta)

#### LOGIC ###

func _init_points() -> void:
	for i in range(points.size()):
		var pos: Vector2= anchor.global_position + init_dir * distance * i
		points[i] = pos
		
		print(points)
		

func _limit_distance_between_points(delta: float) -> void:
	points[0] = anchor.global_position
	
	for i in range(1, points.size()):
		
		var dist: Vector2= (points[i] - points[i-1]).limit_length(distance)
		
		points[i] = points[i-1] + dist
		
