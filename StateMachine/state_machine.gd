extends State
class_name StateMachine

@export var set_to_default_state_at_ready: bool= false

var current_state: State = null:
	set(state):
		if state != current_state and not is_locked_recur():
			if current_state != null:
				current_state.exit()
			previous_state = current_state
			
			current_state = state
			if current_state != null:
				current_state.enter()
			
			state_changed.emit(current_state)

var previous_state: State
var state_locked: bool = false

signal state_changed(state)
signal state_changed_recur(state, deep_state)

#### BUILT-IN ####

func _ready() -> void:
	#Set to default_state
	if set_to_default_state_at_ready: 
		await owner.ready
		set_to_default_state()
	
	#Connect signals
	state_changed.connect(_on_state_changed)
	
	if state_machine != null:
		state_changed_recur.connect(state_machine._on_State_state_changed_recur)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

#### LOGIC ###

func get_state() :
	return current_state

func get_state_name() -> String:
	if current_state == null:
		return ""
	else:
		return current_state.name

func set_state_with_string(state_name: String):
	for state in get_children():
		if state.name == state_name:
			current_state = state
			
			if state_machine is StateMachine:
				state_machine.set_state_with_string(self.name)
			return
		
		elif state is StateMachine:
			state.set_state_with_string(state_name)

func lock_state(state) -> void:
	if state is String:
		set_state_with_string(state)
	else:
		current_state = state
	state_locked = true

func unlock_state() -> void:
	state_locked = false

func set_to_default_state() -> void:
	current_state = get_child(0)

func get_deepest_state() -> State:
	if current_state is StateMachine: return current_state.get_deepest_state()
	if current_state: return current_state
	else : return self

func exit() -> void:
	current_state = null

#### SIGNAL RESPONSES

func _on_state_changed(_state: State) -> void:
	state_changed_recur.emit(current_state, current_state)
	
	previous_state.state_exited.emit()
	
	if current_state:
		if state_machine: state_machine.current_state = self
		
		current_state.state_entered.emit()

func _on_State_state_changed_recur(_state: State ,deep_state: State):
	state_changed_recur.emit(current_state, deep_state)

func is_locked_recur() -> bool:
	if state_locked: return true
	if state_machine: return state_machine.is_locked_recur()
	return false
