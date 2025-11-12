extends AttaqueChoiceInterface
class_name SpellChoiceInterface

func _ready() -> void:
	await Events.spell_buttons_created
	
	super._ready()
