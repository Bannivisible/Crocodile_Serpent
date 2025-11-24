extends Button
class_name CSCategoryButton

@export var cs_data_array: Array[CombatSkillData]

func _on_cs_interface_on_screen_changed(on_screen: Variant) -> void:
	if on_screen:
		focus_mode = Control.FOCUS_ALL
	else :
		focus_mode = Control.FOCUS_NONE
		if has_focus(): release_focus()


func _on_tab_container_tab_changed(tab: int) -> void:
	if tab != 0 and has_focus(): release_focus()
