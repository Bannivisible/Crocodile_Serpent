extends TabContainer

var previous_tab: int:
	set(value):
		previous_tab = value
		previous_tab_changed.emit(previous_tab)
signal previous_tab_changed(prev_tab: int)

var curr_tab: int:
	set(value):
		previous_tab = curr_tab
		curr_tab = value
		current_tab = curr_tab

#func _ready() -> void:
	#tab_changed.connect(_on_tab_changed)

func _on_cs_interface_on_screen_changed(on_screen: Variant) -> void:
	if on_screen: curr_tab = 0

func _on_cs_interface_cs_category_selected() -> void:
	curr_tab = 1

func _on_cs_interface_cancel() -> void:
	if curr_tab > 0: curr_tab -= 1
