extends Label

@export var timer: Timer= get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not timer: return
	
	if not timer.is_stopped():
		text = str(roundf(timer.time_left))
	else :
		text = str(timer.wait_time)
