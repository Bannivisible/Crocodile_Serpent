extends TabContainer



func _on_cs_interface_on_screen_changed(on_screen: Variant) -> void:
	if on_screen: current_tab = 0

func _on_cs_interface_spell_category_selected() -> void:
	current_tab = 1

func _on_cs_interface_cancel() -> void:
	if current_tab > 0: current_tab -= 1
