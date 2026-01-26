extends Button
class_name CSButton

var cs: CombatSkillData

signal cs_selected(cs_data: CombatSkillData)

func _ready() -> void:
	pressed.connect(func(): cs_selected.emit(cs))
	_connect_focus_signal()

func _init(cs_data: CombatSkillData) -> void:
	cs = cs_data
	_set_up()

func _set_up() -> void:
	text = cs.name
	custom_minimum_size = Vector2(0.0, 60.0)

func _on_cs_interface_on_screen_changed(on_screen: bool) -> void:
	if not on_screen and has_focus():
		release_focus()

func _connect_focus_signal() -> void:
	var data_manager: CSInterfacceDataManager= %CSInterfaceDataManager
	focus_entered.connect(data_manager._on_cs_button_focus_entered.bind(cs))


