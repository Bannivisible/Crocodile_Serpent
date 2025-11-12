extends Button


func _on_cs_interface_on_screen_changed(on_screen: Variant) -> void:
	if on_screen:
		focus_mode = Control.FOCUS_ALL
	else :
		focus_mode = Control.FOCUS_NONE
		if has_focus(): release_focus()
