extends GridContainer

var current_spells_data: Array[SpellData]= []:
	set(value):
		if value != current_spells_data:
			current_spells_data = value
			current_spells_data_changed.emit(current_spells_data)

signal current_spells_data_changed(spell_data)
signal buttons_created()

#### BUILT-IN ####

func _ready() -> void:
	current_spells_data_changed.connect(_on_current_spells_data_changed)

#### LOGICS ####

func _add_buttons(spell: SpellData) -> void:
	var button := SpellButton.new(spell)
	var cs_interface: CSInterface= owner
	
	cs_interface.on_screen_changed.connect(button._on_cs_interface_on_screen_changed)
	button.spell_selected.connect(cs_interface._on_cs_selected)
	
	add_child(button)

#### SIGNAL RESPONSES ####

func _on_cs_interface_data_manager_spell_category_sellected(spells_data: Array[SpellData]) -> void:
	current_spells_data = spells_data
	buttons_created.emit()

func _on_current_spells_data_changed(_spell_data) -> void:
	Utiles.free_all_children(self)
	
	for spell in current_spells_data:
		_add_buttons(spell)
	
	Utiles.setup_grid_child_neighbour(self)

func _on_tab_container_tab_changed(tab: int) -> void:
	await buttons_created
	if tab == 1 and get_child_count() > 0:
		await get_tree().process_frame
		get_child(0).grab_focus()
