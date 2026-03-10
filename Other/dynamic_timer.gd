extends Timer
class_name DynamicTimer

@export var time_max: float= 10.0

@export var warnings_steps: Array[float]:
	set(value):
		warnings_steps = value
		_innit_warnings_reach()
var warnings_reach: Array[bool]

var innit_wait_time := wait_time

signal time_added(seconds: float)
signal warning_step_reach(seconds: float, warning_id: int)
signal warning_step_unreach(warning_id: int)

#### BUILT IN ####

func _ready() -> void:
	timeout.connect(_on_timeout)

func _process(_delta: float) -> void:
	if not is_stopped():
		pass

#### INNIT ####

func _innit_warnings_reach() -> void:
	warnings_reach = []
	for i in warnings_steps.size():
		warnings_reach.append(false)

#### LOGIC ####

func _update_warnings_steps() -> void:
	for i in warnings_steps.size():
		if _is_step_just_reach(i):
			warnings_reach[i] = true
			warning_step_reach.emit(time_left, i)

func add_time(seconds: float) -> void:
	if is_stopped():
		wait_time += seconds
	else :
		var new_wait_time: float= time_left + seconds
		stop()
		
		if time_max > 0.0: new_wait_time = min(new_wait_time, time_max)
		
		start(new_wait_time)
		
		for i in warnings_steps.size():
			if not _is_step_just_reach(i):
				warnings_reach[i] = false
				warning_step_unreach.emit(i)
	
	time_added.emit(seconds)

func _is_step_just_reach(step_id: int) -> bool:
	if warnings_reach[step_id] == true:
		return false
		
	if warnings_steps[step_id] >= time_left:
		return true
	
	return false

#### SIGNALS RESPONSES ####

func _on_timeout() -> void:
	wait_time = innit_wait_time
