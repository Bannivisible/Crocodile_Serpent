extends Button
class_name SpellButton

var spell: SpellData

signal spell_selected(spell_data: SpellData)

func _ready() -> void:
	pressed.connect(func(): spell_selected.emit(spell))

func _init(spell_data: SpellData) -> void:
	spell = spell_data
	_set_up()

func _set_up() -> void:
	text = spell.name
	custom_minimum_size = Vector2(0.0, 60.0)

func _on_cs_interface_on_screen_changed(on_screen: bool) -> void:
	if not on_screen and has_focus():
		release_focus()
