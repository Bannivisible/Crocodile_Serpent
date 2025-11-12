extends Reactive
class_name ReactiveString

func _init(initial_value : String= "", initial_possessor : Reactive = null) -> void:
	super._init(initial_possessor)
	value = initial_value

@export var value : String:
	set(v):
		value = v
		reactive_changed.emit(self)
		return value
