extends Node
class_name CSInterfacceDataManager

@export_group("Statistics")

@export var player_statistics: CharacStatistics
@export var wizard_statistics: Wizard_statistics

@export_group("Combat Skill Data")

@export var water_spells_data: Array[CombatSkillData]
@export var fire_spells_data: Array[CombatSkillData]
@export var wind_spells_data: Array[CombatSkillData]
@export var lightning_spells_data: Array[CombatSkillData]
@export var ice_spells_data: Array[CombatSkillData]
@export var weapons_data: Array[CombatSkillData]

@export_group("Style Boxes")

@export var spell_style_boxes: Dictionary[String ,StyleBox]
@export var weapon_style_boxes: Dictionary[String ,StyleBox]


var current_cs_datas: Array[CombatSkillData]

#### BUILT-IN ####
func _ready() -> void:
	%WaterButton.pressed.connect(_on_cs_category_button_pressed.bind(water_spells_data))
	%FireButton.pressed.connect(_on_cs_category_button_pressed.bind(fire_spells_data))
	%WindButton.pressed.connect(_on_cs_category_button_pressed.bind(wind_spells_data))
	%LightningButton.pressed.connect(_on_cs_category_button_pressed.bind(lightning_spells_data))
	%IceButton.pressed.connect(_on_cs_category_button_pressed.bind(ice_spells_data))
	%WeaponButton.pressed.connect(_on_cs_category_button_pressed.bind(weapons_data))
	
	var cs_button: Button= get_node_or_null("%CSButton1")
	var n: int= 1
	
	while cs_button != null:
		cs_button.focus_entered.connect(_on_cs_button_focus_entered.bind(n-1))
		
		n += 1
		cs_button = get_node_or_null("%CSButton" + str(n))
	
	%DoublePageTabContainer


#### LOGIC ####
func _set_stat_label_text(stat_name: String) -> void:
	var label: Label = get_node_or_null("%" + Utiles.snake_case_to_camel_case(stat_name) + "ValueLabel")
	
	if label:
		label.text = str(player_statistics.get(stat_name))


func _set_health_label_text() -> void:
	var health: float= player_statistics.health
	var max_health: float= player_statistics.max_health
	
	var text: String= str(health) + " / " + str(max_health)
	%MaxHealthValueLabel.text = text
	%TWMaxHealthValueLabel.text = text


func _update_stardust_progress_bar() -> void:
	var stardust_progress_bar: ProgressBar = %StardustTextureProgressBar
	
	var max_stardust: float= wizard_statistics.max_stardust
	stardust_progress_bar.max_value = max_stardust
	%TWStardustTextureProgressBar.max_value = max_stardust
	
	var stardust: float= wizard_statistics.stardust
	stardust_progress_bar.value = stardust
	%StardustTextureProgressBar.value = stardust


func _update_critical_value(weapon_stat: WeaponStatistics) -> void:
	%CriteCoefValueLabel.text = "X " + str(weapon_stat.crit_coef)
	%CriteRateValueLabel.text = str(weapon_stat.crit_rate) + " %"


func _get_cs_button_count() -> int:
	var n := 0
	
	while get_node_or_null("%CSButton" + str(n + 1)) != null:
		n += 1
	
	return n

#### SIGNAL RESPONSES ###
func _on_cs_category_button_pressed(cs_datas: Array[CombatSkillData]) -> void:
	current_cs_datas = cs_datas
	
	for i in range(1, _get_cs_button_count() + 1):
		var button: Button= get_node("%CSButton" + str(i))
		
		button.visible = i <= cs_datas.size()
		
		if i <= cs_datas.size():
			button.text = cs_datas[i - 1].name
		
			var style_boxes: Dictionary[String, StyleBox]= weapon_style_boxes if cs_datas == weapons_data else spell_style_boxes
			
			for key in style_boxes:
				button.add_theme_stylebox_override(key, style_boxes[key])


func _on_cs_button_focus_entered(id: int) -> void:
	if current_cs_datas.is_empty(): return
	
	%DescriptionLabel.text = current_cs_datas[id].description
	%TextureRect.texture = current_cs_datas[id].icone


func _on_player_statistics_stat_updated(stat_name: String) -> void:
	if stat_name == "max_health": _set_health_label_text()
	else :
		_set_stat_label_text(stat_name)
		_set_stat_label_text("TW" +  stat_name)


func _on_player_statistics_variable_stat_chanded(stat_name: String, _value: float) -> void:
	if not stat_name == HealthComponent.HEALTH_STAT_NAME: return
	_set_health_label_text()


func _on_wizard_statistics_stat_updated(stat_name: String) -> void:
	var max_stardust_stat_name: String= Statistics.MAX_STAT_PREFIX + StardustComponent.STARDUST_STAT_NAME
	if stat_name == max_stardust_stat_name:
		_update_stardust_progress_bar()


func _on_wizard_statistics_variable_stat_chanded(stat_name: String, _value: float) -> void:
	if not stat_name == StardustComponent.STARDUST_STAT_NAME: return
	_update_stardust_progress_bar()


func _on_double_page_tab_container_tab_changed(tab: int) -> void:
	if tab == 0:
		%TextureRect.texture = null
		%DescriptionLabel.text = ""
