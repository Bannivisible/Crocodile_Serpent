extends Node
class_name CSInterfacceDataManager

@export var player_statistics: Statistcs

signal spell_category_sellected(spells_data: Array[SpellData])

func _on_spell_category_button_spell_category_selected(spells_data: Array[SpellData]) -> void:
	spell_category_sellected.emit(spells_data)
