extends Reactive
class_name ReactiveInt

func _init(initial_value : int= 0, initial_possessor : Reactive = null) -> void:
	super._init(initial_possessor)
	value = initial_value

@export var value : int:
	set(v):
		value = v
		reactive_changed.emit(self)
		return value
