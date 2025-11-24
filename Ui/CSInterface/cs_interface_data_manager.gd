extends Node
class_name CSInterfacceDataManager

@export var player_statistics: Statistcs

signal cs_category_sellected(cs_data: Array[CombatSkillData])

func _ready() -> void:
	_connect_cs_category_buttons_signals()

func _connect_cs_category_buttons_signals() -> void:
	for child in %CSCategoryGridContainer.get_children():
		var cs_categ_button: CSCategoryButton= child
		cs_categ_button.pressed.connect(
			_on_cs_category_button_pressed.bind(cs_categ_button.cs_data_array))

func _on_cs_category_button_pressed(cs_data: Array[CombatSkillData]) -> void:
	cs_category_sellected.emit(cs_data)
