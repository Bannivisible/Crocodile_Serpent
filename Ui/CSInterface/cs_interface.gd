extends Control
class_name CSInterface

@onready var data_manager: CSInterfacceDataManager = $CSInterfaceDataManager

@export var show_animation_ease: Tween.EaseType
@export var show_animation_trans: Tween.TransitionType

signal on_screen_changed(on_screen)
var on_screen: bool= false:
	set(value):
		if value != on_screen:
			on_screen = value
			on_screen_changed.emit(on_screen)
			Events.cs_interface_on_screen_changed.emit(on_screen)

var tween: Tween


const SHOW_ANIMATION_DURATION: float= 0.5

signal on_screen_animation_finished()
signal cs_category_selected()
signal cancel()

#### BUILT_IN ####
func _ready() -> void:
	data_manager.player_statistics.stat_updated.connect(_on_player_statistics_stat_updated)
	data_manager.player_statistics.variable_stat_changed.connect(_on_player_statistics_variable_stat_chanded)
	data_manager.wizard_statistics.stat_updated.connect(_on_wizard_statistics_stat_updated)
	data_manager.wizard_statistics.variable_stat_changed.connect(_on_wizard_statistics_variable_stat_chanded)
	
	_connect_cs_category_buttons_signals()
	
	#_update_stardust_progress_bar()
	
	for stat_name in data_manager.player_statistics.statistics.keys():
		_set_stat_label_text(stat_name)
	
	on_screen_changed.connect(func(_value):
		if not on_screen: release_focus())

#### INPUTS ####
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("choose"):
		display()
	
	if Input.is_action_just_pressed("cancel"):
		cancel.emit()

#### LOGIC ####
func display() -> void:
	if tween: tween.kill()
	var to = -size.y if on_screen else 0.0
	on_screen = !on_screen
	
	tween = create_tween().set_ease(show_animation_ease).set_trans(show_animation_trans)
	tween.tween_property(self, "position:y", to, SHOW_ANIMATION_DURATION)
	tween.tween_callback(func():on_screen_animation_finished.emit())

func _emit_event_cs_selected_signal(cs_data) -> void:
	Events.combat_skill_selected.emit(cs_data)

func _set_stat_label_text(stat_name: String) -> void:
	var label: Label = get_node_or_null("%" + Utiles.snake_case_to_camel_case(stat_name) + "ValueLabel")
	if label == %MaxHealthValueLabel:
		_set_health_label_text()
	
	elif label:
		label.text = str(data_manager.player_statistics.get(stat_name))

func _set_health_label_text() -> void:
	var label: Label= %MaxHealthValueLabel
	
	var health: float= data_manager.player_statistics.health
	var max_health: float= data_manager.player_statistics.max_health
	
	label.text = str(health) + " / " + str(max_health)


func _connect_cs_category_buttons_signals() -> void:
	for child in %CSCategoryGridContainer.get_children():
		var cs_categ_button: CSCategoryButton= child
		cs_categ_button.pressed.connect(_on_cs_category_button_pressed)


func _update_stardust_progress_bar() -> void:
	var stardust_progress_bar: ProgressBar = %StardustProgressBar
	
	var max_stardust: float= data_manager.wizard_statistics.max_stardust
	stardust_progress_bar.max_value = max_stardust
	
	var stardust: float= data_manager.wizard_statistics.stardust
	stardust_progress_bar.value = stardust

func _update_critical_value(weapon_stat: WeaponStatistics) -> void:
	%CriteCoefValueLabel.text = "X " + str(weapon_stat.crit_coef)
	%CriteRateValueLabel.text = str(weapon_stat.crit_rate) + " %"


#### SIGNAL RESPONSES ####
func _on_cs_category_button_pressed() -> void:
	cs_category_selected.emit()

func _on_cs_selected(cs_data: CombatSkillData) -> void:
	display()
	tween.tween_callback(func():
		Events.combat_skill_selected.emit(cs_data)
	)

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
