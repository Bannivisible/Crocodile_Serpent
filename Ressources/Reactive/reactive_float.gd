extends Reactive
class_name ReactiveFloat

func _init(initial_value : float= 0.0, initial_possessor : Reactive = null) -> void:
	super._init(initial_possessor)
	value = initial_value

@export var value : float:
	set(v):
		value = v
		reactive_changed.emit(self)
		return value
