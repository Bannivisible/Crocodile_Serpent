extends Range
class_name TimerRange

@export var timer: Timer= get_parent():
	set = _set_timer


func _set_timer(new_timer: Timer) -> void:
	if timer:
		timer.timeout.disconnect(_on_timer_timeout)
		if timer is DynamicTimer:
			timer.time_added.disconnect(_on_timer_time_added)
	
	timer = new_timer
	if timer != null:
		timer.timeout.connect(_on_timer_timeout)
		if timer is DynamicTimer:
			timer.time_added.connect(_on_timer_time_added)
		
		max_value = timer.wait_time
		value = max_value

func _ready() -> void:
	min_value = 0.0


func _physics_process(_delta: float) -> void:
	if timer.is_stopped(): return
	
	value = timer.time_left

func _on_timer_timeout() -> void:
	pass

func _on_timer_time_added(seconds: float) -> void:
	if timer.is_stopped(): max_value = timer.wait_time
	value += seconds
