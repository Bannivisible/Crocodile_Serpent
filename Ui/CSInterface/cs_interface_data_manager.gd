extends Node
class_name CSInterfacceDataManager

@export var player_statistics: CharacStatistics
@export var wizard_statistics: Wizard_statistics

signal cs_category_sellected(cs_data_array: Array[CombatSkillData])
signal cs_focus_changed(cs_data: CombatSkillData)


#func _ready() -> void:
	#_connect_cs_category_buttons_signals()

#func _connect_cs_category_buttons_signals() -> void:
	#for child in %CSCategoryGridContainer.get_children():
		#var cs_categ_button: CSCategoryButton= child
		#cs_categ_button.pressed.connect(
			#_on_cs_category_button_pressed.bind(cs_categ_button.cs_data_array))

func _on_cs_category_button_pressed(cs_data: Array[CombatSkillData]) -> void:
	cs_category_sellected.emit(cs_data)

func _on_cs_button_focus_entered(cs_data: CombatSkillData) -> void:
	print(cs_data)
	cs_focus_changed.emit(cs_data)

func _set_stat_label_text(stat_name: String) -> void:
	var label: Label = get_node_or_null("%" + Utiles.snake_case_to_camel_case(stat_name) + "ValueLabel")
	if label == %MaxHealthValueLabel:
		_set_health_label_text()
	
	elif label:
		label.text = str(player_statistics.get(stat_name))


func _set_health_label_text() -> void:
	var label: Label= %MaxHealthValueLabel
	
	var health: float= player_statistics.health
	var max_health: float= player_statistics.max_health
	
	label.text = str(health) + " / " + str(max_health)


func _update_stardust_progress_bar() -> void:
	var stardust_progress_bar: ProgressBar = %StardustTextureProgressBar
	
	var max_stardust: float= wizard_statistics.max_stardust
	stardust_progress_bar.max_value = max_stardust
	
	var stardust: float= wizard_statistics.stardust
	stardust_progress_bar.value = stardust


func _update_critical_value(weapon_stat: WeaponStatistics) -> void:
	%CriteCoefValueLabel.text = "X " + str(weapon_stat.crit_coef)
	%CriteRateValueLabel.text = str(weapon_stat.crit_rate) + " %"


#### SIGNAL RESPONSES ###

func _on_player_statistics_stat_updated(stat_name: String) -> void:
	_set_stat_label_text(stat_name)


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
