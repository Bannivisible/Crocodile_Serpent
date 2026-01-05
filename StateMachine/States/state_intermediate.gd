extends State
class_name StateIntermediate

@export var next_state: State
@export_range(0.1, 999.9, 0.1) var wait_time: float:
	set(value):
		wait_time = value
		if wait_time >0.0:
			timer = _create_timer()

var timer: Timer

func _create_timer() -> Timer:
	if timer: timer.queue_free()
	
	var nv_timer := Timer.new()
	nv_timer.wait_time = wait_time
	add_child(nv_timer)
	nv_timer.timeout.connect(_on_timer_timeout)
	
	return nv_timer

func enter() -> void:
	timer.start()

func exit() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	next_state.state_machine.current_state = next_state
