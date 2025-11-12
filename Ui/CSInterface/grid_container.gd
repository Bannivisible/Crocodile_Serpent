extends GridContainer

func _ready() -> void:
	Utiles.setup_grid_child_neighbour(self)

func _on_tab_container_tab_changed(tab: int) -> void:
	if tab == 0:
		if not is_node_ready(): await ready
		await get_tree().process_frame
		get_child(0).grab_focus()
