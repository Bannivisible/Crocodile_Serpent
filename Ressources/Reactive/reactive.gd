extends Resource
class_name Reactive

var possessor : Reactive:
	set(v):
		if possessor != null:
			reactive_changed.disconnect(possessor._propagate)
		possessor = v
		if possessor != null:
			reactive_changed.connect(possessor._propagate)

signal reactive_changed(reactive)

func _init(initial_possessor : Reactive = null) -> void:
	possessor = initial_possessor

func _propagate(_reactive : Reactive = null) -> void:
	reactive_changed.emit(self)

func manually_emit() -> void:
	reactive_changed.emit(self)
