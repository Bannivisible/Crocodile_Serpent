extends GridContainer

var current_cs_data: Array[CombatSkillData]= []:
	set(value):
		if value != current_cs_data:
			current_cs_data = value
			current_cs_data_changed.emit(current_cs_data)

signal current_cs_data_changed(cs_data)

#### BUILT-IN ####

#func _ready() -> void:
	#current_cs_data_changed.connect(_on_current_cs_data_changed)

#### LOGICS ####

#func _add_buttons(cs: CombatSkillData) -> void:
	#var button := CSButton.new(cs)
	#var cs_interface: CSInterface= owner
	#
	#cs_interface.on_screen_changed.connect(button._on_cs_interface_on_screen_changed)
	#button.cs_selected.connect(cs_interface._on_cs_selected)
	#
	#add_child(button)

#### SIGNAL RESPONSES ####

func _on_cs_interface_data_manager_cs_category_sellected(cs_data: Array[CombatSkillData]) -> void:
	current_cs_data = cs_data

#func _on_current_cs_data_changed(_cs_data) -> void:
	#Utiles.free_all_children(self)
	#
	#for cs in current_cs_data:
		#_add_buttons(cs)
	#
	#Utiles.setup_grid_child_neighbour(self)

#func _on_tab_container_tab_changed(tab: int) -> void:
	#if tab == 1 and get_child_count() > 0:
		#await get_tree().process_frame
		#get_child(0).grab_focus()
