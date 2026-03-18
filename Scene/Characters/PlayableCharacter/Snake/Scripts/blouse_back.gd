extends AnimatedSprite2D

@export var frame_pos: Array[Vector2]


##### BUILT-IN ####
func _ready() -> void:
	frame_changed.connect(_on_frame_changed)


func _enter_tree() -> void:
	_set_pos_with_frame()

#### LOGIC ####
func _set_pos_with_frame() -> void:
	position = frame_pos[frame]

#### SIGNALS RESPONSES ####
func _on_frame_changed() -> void:
	_set_pos_with_frame()
