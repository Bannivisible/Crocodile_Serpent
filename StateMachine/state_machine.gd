extends State
class_name StateMachine

@export var current_state: State = null:
	set = _set_current_state

func _set_current_state(state: State) -> void:
	if state != current_state and not is_locked_recur():
		previous_state = current_state
		current_state = state
		
		if previous_state:
			previous_state.exit()
		
		if current_state != null:
			current_state.enter()
		
		state_changed.emit(current_state)

var previous_state: State
var state_locked: bool = false

signal state_changed(state: State)
signal state_changed_recur(state: State, deep_state: State)

#### BUILT-IN ####

func _ready() -> void:
	#Connect signals
	state_changed.connect(_on_state_changed)
	
	if state_machine != null:
		state_changed_recur.connect(state_machine._on_State_state_changed_recur)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

#### LOGIC ####

func set_state(state: State) -> void:
	for child in get_children():
		if child == state: 
			current_state = child
			return
		
		elif child is StateMachine:
			child.set_state(state)

func set_state_with_string(state_name: String) -> void:
	for state in get_children():
		if state.name == state_name:
			current_state = state
		
		elif state is StateMachine:
			state.set_state_with_string(state_name)

func set_to_default_state() -> void:
	for child in get_children():
		if child is State:
			current_state = child
			return

func lock_state(state) -> void:
	if state is String:
		set_state_with_string(state)
	else:
		set_state(state)
	state_locked = true

func unlock_state() -> void:
	state_locked = false

func is_locked_recur() -> bool:
	if state_locked: return true
	if state_machine: return state_machine.is_locked_recur()
	return false

#### GETTER ####

func get_state() :
	return current_state

func get_state_name() -> String:
	if not current_state:
		return ""
	else:
		return current_state.name

func get_deepest_state() -> State:
	if current_state is StateMachine: return current_state.get_deepest_state()
	if current_state: return current_state
	else : return self

func get_chained_state_list() -> Array[State]:
	var chained: Array[State]= []
	
	if current_state:
		chained.append(current_state)
		if current_state is StateMachine:
			chained += current_state.get_chained_state_list()
	
	return chained

func get_chained_state_string(separ_symbol: String= "-") -> String:
	var chained: String= get_state_name()
	
	if current_state is StateMachine:
		chained += separ_symbol + current_state.get_chained_state_string()
	
	return chained

#### INHERITENCE ####

func exit() -> void:
	current_state = null

#### SIGNAL RESPONSES ####

func _on_state_changed(_state: State) -> void:
	state_changed_recur.emit(current_state, current_state)
	
	if previous_state:
		previous_state.state_exited.emit()
	
	if current_state:
		current_state.state_entered.emit()
		
		if not is_current_state() and state_machine != null:
				state_machine.current_state = self

func _on_State_state_changed_recur(_state: State ,deep_state: State):
	state_changed_recur.emit(current_state, deep_state)
