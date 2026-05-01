@tool
extends ConditionLeaf

@export var emitteur: Node
@export var signal_name: StringName

var signal_receive: bool= false

func _ready() -> void:
	if not emitteur or signal_name == "": return
	emitteur.connect(signal_name, _on_emitteur_emit_signal)


func tick(actor: Node, blackboard: Blackboard) -> int:
	if signal_receive:
		signal_receive = false
		return SUCCESS
	
	return FAILURE


func _on_emitteur_emit_signal() -> void:
	signal_receive = true
